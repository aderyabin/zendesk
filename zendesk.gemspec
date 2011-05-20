# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "zendesk/version"

Gem::Specification.new do |s|
  s.name = %q{zendesk}
  s.version = Zendesk::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors = ["Andrey Deryabin"]
  s.date = %q{2011-05-20}
  s.summary = %q{Ruby wrapper around the Zendesk API}
  s.description = %q{Ruby wrapper around the Zendesk API}
  s.email = %q{deriabin@gmail.com}
  s.homepage = %q{http://github.com/aderyabin/zendesk}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end

