require 'java'

load 'jruby_plugin_startup.rb'

j = JrubyPluginStartup.new
j.start_view [1, 2, 3]
