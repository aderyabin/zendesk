# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{zendesk}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Andrey Deryabin"]
  s.date = %q{2011-05-19}
  s.description = %q{Ruby wrapper around the Zendesk API}
  s.email = %q{deriabin@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    "Gemfile",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "lib/zendesk.rb",
    "lib/zendesk/comment.rb",
    "lib/zendesk/lib/constants.rb",
    "lib/zendesk/lib/properties.rb",
    "lib/zendesk/lib/rest_object.rb",
    "lib/zendesk/resource.rb",
    "lib/zendesk/ticket.rb",
    "lib/zendesk/user.rb",
    "lib/zendesk/version.rb",
    "spec/comment_spec.rb",
    "spec/spec_helper.rb",
    "spec/ticket_spec.rb",
    "zendesk.gemspec"
  ]
  s.homepage = %q{http://github.com/aderyabin/zendesk}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Ruby wrapper around the Zendesk API}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.6.0"])
    else
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.6.0"])
    end
  else
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.6.0"])
  end
end

