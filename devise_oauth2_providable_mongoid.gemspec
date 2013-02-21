# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "devise/oauth2_providable/mongoid/version"

Gem::Specification.new do |s|
  s.name        = "devise_oauth2_providable_mongoid"
  s.version     = Devise::Oauth2Providable::Mongoid::VERSION
  s.authors     = ["HumanProxy"]
  s.email       = ["benoit.molenda@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Mongoid extention for model abtract devise_oauth2_providable}
  s.description = %q{Provide behavior and dependencies to setup devise_oauth2_providable with mongoid ORM}

  #s.rubyforge_project = "devise_oauth2_providable_mongoid"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency(%q<rails>, [">= 3.1.0"])
  s.add_runtime_dependency "mongoid"
  #s.add_runtime_dependency "devise_oauth2_providable"
  #s.add_runtime_dependency "actionpack", '= 3.2.2'
  #s.add_development_dependency gem "mongoid-rspec", ">= 1.4.1", git: "https://github.com/evansagge/mongoid-rspec.git"
  s.add_development_dependency "database_cleaner"
  s.add_development_dependency 'rb-fsevent'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'growl' #grow notification
  s.add_development_dependency(%q<pry>, ['0.9.6.2'])
  s.add_development_dependency(%q<rspec-rails>)
  s.add_development_dependency(%q<shoulda-matchers>)
  s.add_development_dependency(%q<pry>, ['0.9.6.2'])
  s.add_development_dependency(%q<factory_girl>)
  s.add_development_dependency(%q<factory_girl_rspec>)
  s.add_development_dependency(%q<rake>, ['0.9.2.2'])
end
