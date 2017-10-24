$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'firmenwissen/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'firmenwissen'
  s.version     = Firmenwissen::VERSION
  s.authors     = ['Gerrit Seger']
  s.email       = ['gerrit.seger@gmail.com']
  s.summary     = 'Ruby client for the FirmenWissen API'
  s.license     = 'MIT'

  s.files = Dir['{lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'addressable'

  s.add_development_dependency 'pry'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'webmock'
end
