require 'asm_support'
require 'pp'

include AsmSupport

# Default to PrinterVisitor
klass = PrinterVisitor

# Loop through each .class file given on the command line
ARGV.each do |arg|
  begin
    new_klass = eval arg
  rescue Exception => exc
  end
  if Class === new_klass
    klass = new_klass
  else
    builder = RubyInterfaceImplementationBuilder.new klass
    result = builder.build_for_filename arg
    puts result
  end
end
