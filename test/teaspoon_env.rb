require "workarea/testing/teaspoon"

Teaspoon.configure do |config|
  config.root = Workarea::CyberSource::Engine.root
  Workarea::Teaspoon.apply(config)
end
