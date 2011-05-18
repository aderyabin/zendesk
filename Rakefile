# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "zendesk"
  gem.homepage = "http://github.com/aderyabin/zendesk"
  gem.license = "MIT"
  gem.summary = %Q{Ruby wrapper around the Zendesk API}
  gem.description = %Q{Ruby wrapper around the Zendesk API}
  gem.email = "deriabin@gmail.com"
  gem.authors = ["Andrey Deryabin"]
  # dependencies defined in Gemfile
end