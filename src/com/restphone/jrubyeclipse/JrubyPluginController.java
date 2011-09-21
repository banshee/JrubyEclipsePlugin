package com.restphone.jrubyeclipse;

import org.jruby.Ruby;
import org.jruby.RubyObject;
import org.jruby.javasupport.util.RuntimeHelpers;
import org.jruby.runtime.builtin.IRubyObject;
import org.jruby.javasupport.JavaUtil;
import org.jruby.RubyClass;


public class JrubyPluginController extends RubyObject  {
    private static final Ruby __ruby__ = Ruby.getGlobalRuntime();
    private static final RubyClass __metaclass__;

    static {
        String source = new StringBuilder("require 'java'\n" +
            "\n" +
            "java_package 'com.restphone.jrubyeclipse'\n" +
            "\n" +
            "class JrubyPluginController\n" +
            "  def create_filter ruby_file_name\n" +
            "    ruby_file_contents = IO.read ruby_file_name\n" +
            "    eval ruby_file_contents\n" +
            "    eclipse_callback\n" +
            "  end\n" +
            "end\n" +
            "").toString();
        __ruby__.executeScript(source, "jruby/jruby_plugin_controller.rb");
        RubyClass metaclass = __ruby__.getClass("JrubyPluginController");
        metaclass.setRubyStaticAllocator(JrubyPluginController.class);
        if (metaclass == null) throw new NoClassDefFoundError("Could not load Ruby class: JrubyPluginController");
        __metaclass__ = metaclass;
    }

    /**
     * Standard Ruby object constructor, for construction-from-Ruby purposes.
     * Generally not for user consumption.
     *
     * @param ruby The JRuby instance this object will belong to
     * @param metaclass The RubyClass representing the Ruby class of this object
     */
    private JrubyPluginController(Ruby ruby, RubyClass metaclass) {
        super(ruby, metaclass);
    }

    /**
     * A static method used by JRuby for allocating instances of this object
     * from Ruby. Generally not for user comsumption.
     *
     * @param ruby The JRuby instance this object will belong to
     * @param metaclass The RubyClass representing the Ruby class of this object
     */
    public static IRubyObject __allocate__(Ruby ruby, RubyClass metaClass) {
        return new JrubyPluginController(ruby, metaClass);
    }
        
    /**
     * Default constructor. Invokes this(Ruby, RubyClass) with the classloader-static
     * Ruby and RubyClass instances assocated with this class, and then invokes the
     * no-argument 'initialize' method in Ruby.
     *
     * @param ruby The JRuby instance this object will belong to
     * @param metaclass The RubyClass representing the Ruby class of this object
     */
    public JrubyPluginController() {
        this(__ruby__, __metaclass__);
        RuntimeHelpers.invoke(__ruby__.getCurrentContext(), this, "initialize");
    }

    
    public Object create_filter(Object ruby_file_name) {
        IRubyObject ruby_ruby_file_name = JavaUtil.convertJavaToRuby(__ruby__, ruby_file_name);
        IRubyObject ruby_result = RuntimeHelpers.invoke(__ruby__.getCurrentContext(), this, "create_filter", ruby_ruby_file_name);
        return (Object)ruby_result.toJava(Object.class);

    }

}
