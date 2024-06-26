# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'anystyle/version'

Gem::Specification.new do |s|
  s.name         = 'anystyle'
  s.version      = AnyStyle::VERSION.dup
  s.platform     = Gem::Platform::RUBY
  s.authors      = ['Sylvester Keil']
  s.email        = ['http://sylvester.keil.or.at']
  s.homepage     = 'http://anystyle.io'
  s.summary      = 'Smart and fast bibliography parser.'
  s.description  = 'A sophisticated parser for academic reference lists and bibliographies based on machine learning algorithms using conditional random fields.'
  s.license      = 'BSD-2-Clause'
  s.executables  = []
  s.require_path = 'lib'

  s.required_ruby_version = '>= 2.2'

  s.add_runtime_dependency('bibtex-ruby', '~>5.0')
  s.add_runtime_dependency('anystyle-data', '~>1.2')
  s.add_runtime_dependency('gli', '~>2.17')
  s.add_runtime_dependency('wapiti', '~>1.0', '>=1.0.2')
  s.add_runtime_dependency('namae', '~>1.0')

  s.files =
    `git ls-files`.split("\n") - `git ls-files spec`.split("\n") - %w{
      .coveralls.yml
      .gitignore
      .rspec
      .simplecov
      .travis.yml
      Gemfile
      Rakefile
      appveyor.yml
      anystyle.gemspec
      res/core.xml
    }

  s.rdoc_options = %w{
    --line-numbers
    --inline-source
    --title "AnyStyle"
    --main README.md
  }
  s.extra_rdoc_files = %w{README.md LICENSE}

end

# vim: syntax=ruby
