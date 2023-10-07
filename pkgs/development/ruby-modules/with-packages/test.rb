#!/usr/bin/env ruby

# this is a quick and dirty test suite for easier analyzing of breakages in a
# manual testing.
# For automated testing use the test.nix

require 'fileutils'

class FakeGemfile
  attr_reader :gems

  def initialize
    @gems = []
  end

  def source(_source, &block)
    instance_exec(&block)
  end

  def gem(name)
    @gems << name
  end
end

gemfile = File.expand_path(File.join(__dir__, 'Gemfile'))
packages = FakeGemfile.new.instance_eval(File.read(gemfile), gemfile)

test_cases = packages.map { |pkg| [pkg, "require '#{pkg}'"] }.to_h

test_cases.merge!(
  'digest-sha3' => "require 'digest/sha3'",
  'gitlab-markup' => "require 'github/markup'",
  'idn-ruby' => "require 'idn'",
  'net-scp' => "require 'net/scp'",
  'taglib-ruby' => "require 'taglib'",
  'net-ssh' => "require 'net/ssh'",
  'ruby-libvirt' => "require 'libvirt'",
  'ruby-lxc' => "require 'lxc'",
  'rubyzip' => "require 'zip'",
  'sinatra' => "require 'sinatra/base'",
  'libxml-ruby' => "require 'libxml'",
  'ruby-terminfo' => "require 'terminfo'",
  'ovirt-engine-sdk' => "require 'ovirtsdk4'",
  'fog-dnsimple' => "require 'fog/dnsimple'"
)

test_cases['sequel_pg'] = <<~TEST
  require 'pg'
  require 'sequel'
  require 'sequel/adapters/postgresql'
  require 'sequel_pg'
TEST

tmpdir = File.expand_path(File.join(__dir__, 'tests'))
FileUtils.rm_rf(tmpdir)
FileUtils.mkdir_p(tmpdir)

failing = test_cases.reject do |name, test_case|
  test_case = <<~SHELL
    #!/usr/bin/env nix-shell
    #!nix-shell -i ruby -E "(import ../../../.. {}).ruby.withPackages (r: [ r.#{name} ] )"
    #{test_case}
  SHELL

  file = File.join(tmpdir, "#{name}_test.rb")
  File.write(file, test_case)
  FileUtils.chmod('u=wrx', file)

  system(file) && FileUtils.rm(file)
end

exit if failing.empty?

puts "Following gems failed: #{failing.keys.join(' ')}"
puts "tests for failing gems remain in #{tmpdir}"
exit 1
