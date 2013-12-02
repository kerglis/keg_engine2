$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "keg_engine2/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "keg_engine2"
  s.version     = KegEngine2::VERSION
  s.authors     = ["Kristaps Erglis"]
  s.email       = ["kristaps.erglis@gmail.com"]
  s.homepage    = ""
  s.summary     = "KegEngine2 - private set of models/assets/etc to bootstrap new projects"
  s.description = "KegEngine2 - private set of models/assets/etc to bootstrap new projects"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency 'jquery-rails'
  s.add_dependency 'haml-rails'
  s.add_dependency 'sass-rails'
  s.add_dependency 'less-rails'
  s.add_dependency 'acts_as_list'
  s.add_dependency 'awesome_nested_set'

  s.add_dependency 'devise'
  s.add_dependency 'omniauth-facebook'
  s.add_dependency 'config_spartan'
  s.add_dependency 'simple_form'
  s.add_dependency 'state_machine'
  s.add_dependency 'meta_search'
  s.add_dependency 'will_paginate'
  s.add_dependency 'inherited_resources'
  s.add_dependency 'rspec-rails'

  s.add_development_dependency 'quiet_assets'
  s.add_development_dependency 'thin'
  s.add_development_dependency 'capistrano'

end