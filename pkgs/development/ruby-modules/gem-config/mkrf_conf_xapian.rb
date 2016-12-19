require 'rubygems'
require 'rubygems/command.rb'
require 'rubygems/dependency_installer.rb'
require 'rbconfig'

begin
  Gem::Command.build_args = ARGV
rescue NoMethodError
end

# create dummy rakefile to indicate success
f = File.open(File.join(File.dirname(__FILE__), "Rakefile"), "w")
f.write("task :default\n")
f.close
