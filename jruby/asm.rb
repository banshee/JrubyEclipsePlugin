require 'asm_support'

include AsmSupport

# Loop through each .class file given on the command line
ARGV.each do |classfile|
  puts " ---------------- Reading file #{classfile}"
  
#  builder = RubyInterfaceImplementationBuilder.new InterfaceVisitor
#  puts builder.build_for_filename classfile
#  
#  puts 
#  
#  builder = RubyInterfaceImplementationBuilder.new PrinterVisitor
#  puts builder.build_for_filename classfile
#  
#  puts
#  
  builder = RubyInterfaceImplementationBuilder.new DependencyVisitor
  require 'pp'
  pp builder.build_for_filename classfile
  
  puts
end
