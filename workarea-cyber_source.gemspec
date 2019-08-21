$:.push File.expand_path("../lib", __FILE__)

require "workarea/cyber_source/version"

Gem::Specification.new do |s|
  s.name        = "workarea-cyber_source"
  s.version     = Workarea::CyberSource::VERSION
  s.authors     = ["Eric Pigeon"]
  s.email       = ["epigeon@weblinc.com"]
  s.homepage    = "https://github.com/workarea-commerce/workarea-cyber_source"
  s.summary     = "CyberSource integration for Workarea Commerce Platform"
  s.description = "CyberSource integration for Workarea Commerce Platform"

  s.files = `git ls-files`.split("\n")

  s.license = 'Business Software License'

  s.add_dependency "workarea", "~> 3.x"
end
