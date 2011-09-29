require 'java'
require 'asm-3.3.1'

module AsmSupport
  # This lets me type org.objectweb.asm::... instead of Java::OrgObjectwebAsm::...
  def org
    Java::Org
  end

  java_import  org.objectweb.asm::Type

  module AllVisitorInterfaces
    include org.objectweb.asm::MethodVisitor
    include org.objectweb.asm::ClassVisitor
    include org.objectweb.asm::FieldVisitor
    include org.objectweb.asm::AnnotationVisitor
    include org.objectweb.asm.signature::SignatureVisitor
  end

  class GenericVisitor
    include AllVisitorInterfaces
    def initialize
      @result = ""
    end

    def get_result
      @result
    end

    def method_missing name, *args
      return self if name.to_s =~ /^visit.*/
      super
    end
  end

  class PrinterVisitor < GenericVisitor
    def method_missing name, *args
      name_string = name.to_s
      if name_string =~ /visit.*/
        @result << "#{name}\t#{args}" << "\n"
        self
      else
        super
      end
    end
  end

  class InterfaceVisitor < GenericVisitor
    def method_signature_to_java_signature sig
      types = Type.getArgumentTypes sig
      i = ?a.ord
      names = types.map do |t|
        result = "#{t.get_class_name} #{i.chr.to_s}"
        i += 1
        result
      end
      ?( + names.join(", ") + ?)
    end

    def visit_method *args
      signature = args[2]
      name = args[1]
      java_signature = method_signature_to_java_signature signature
      return_type = Type.get_return_type signature
      @result << %Q&java_signature "#{return_type.get_class_name} #{name} #{java_signature}"\n&
      @result << "def #{name} *args\nend\n\n"
      self
    end
  end

  class DependencyVisitor < GenericVisitor
    def initialize
      @result = Hash.new {|hash, k| hash[k] = {}}
      @current_class = nil
    end

    def visit *args
      #      int version,
      #      int access,
      #      String name,
      #      String signature,
      #      String superName,
      #      String[] interfaces);
      if (args.length > 2)
        name = args[2]
        super_name = args[4]
        interfaces = args[5]
        @current_class = name
        depends_on name, super_name
        interfaces.each do |i|
          depends_on name, i
        end
        self
      end
    end

    def visit_method *args
      signature = args[2]
      name = args[1]
      return_type = Type.get_return_type signature
      begin
        depends_on @current_class, return_type.get_internal_name rescue self
      rescue
      end
    end

    def normalize_class_name c
      result = c.to_s
      result = result.sub %r(\[?L?), ""
      result = result.sub ';', ''
      result
    end

    def depends_on klass, d
      return unless d
      return self if klass == d
      k = normalize_class_name klass
      d = normalize_class_name d
      @result[k][d] = 1
      self
    end

    def standard_instruction opcode, type, *args
      depends_on @current_class, type
      self
    end

    def visit_single_arg t
      depends_on @current_class, t
    end

    def visit_annotation first_arg, second_arg, *args
      if String === second_arg
        depends_on @current_class, second_arg
      else
        depends_on @current_class, first_arg
      end
      self
    end

    #String name,
    #String outerName,
    #String innerName,
    #int access);
    def visitInnerClass name, outer_name, inner_name, access
      depends_on @current_class, name
      depends_on @current_class, outer_name
    end

    # void visitMethodInsn(int opcode, String owner, String name, String desc);
    def visit_method_insn opcode, owner, name, desc
      depends_on @current_class, owner
    end

    alias :visitTypeInsn :standard_instruction
    alias :visitFieldInsn :standard_instruction
    alias :visitMethodInsn :standard_instruction
    alias :visitEnum :standard_instruction

    alias :visitFormalTypeParameter :standard_instruction
    alias :visitTypeVariable :standard_instruction
    alias :visitClassType :standard_instruction
    alias :visitInnerClassType :standard_instruction
  end

  class RubyInterfaceImplementationBuilder
    def initialize visitor_class
      @visitor_class = visitor_class
    end

    def build visitor_object, file_input_stream
      class_reader = org.objectweb.asm::ClassReader.new file_input_stream
      class_reader.accept visitor_object, 0
    end

    def name_to_inputstream filename
      f = java.io.File.new filename
      java.io.FileInputStream.new f
    end

    def build_for_filename filename
      inputstream = name_to_inputstream filename
      visitor = @visitor_class.new
      build visitor, inputstream
      visitor.get_result
    end
  end
end
