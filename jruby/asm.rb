require 'rubygems'
require 'asm_support'
require 'rake'
require 'pp'

include AsmSupport

# Default to PrinterVisitor
klass = PrinterVisitor

args = ARGV.dup
args = args.map do |a|
  if a =~ /\*/
    Dir.glob a
  else
    a
  end
end
# Loop through each .class file given on the command line
args.flatten.each do |arg|
  begin
    new_klass = eval arg
  rescue Exception => exc
  end
  if Class === new_klass
    klass = new_klass
  else
    Dir.glob arg do |d|
      builder = RubyInterfaceImplementationBuilder.new klass
      result = builder.build_for_filename d
      puts result
    end
  end
end
