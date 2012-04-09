# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "devise_oauth2_providable_mongoid/version"

Gem::Specification.new do |s|
  s.name        = "devise_oauth2_providable_mongoid"
  s.version     = DeviseOauth2ProvidableMongoid::VERSION
  s.authors     = ["HumanProxy"]
  s.email       = ["benoit.molenda@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "devise_oauth2_providable_mongoid"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "mongoid"
  s.add_runtime_dependency "devise_oauth2_providable"
  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
