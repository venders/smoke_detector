$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "watch_tower/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "watch_tower"
  s.version     = WatchTower::VERSION
  s.authors     = ["Chris Friedrich"]
  s.email       = ["cfriedrich@lumoslabs.com"]
  s.homepage    = "https://github.com/lumoslabs/watch_tower"
  s.summary     = "Lumos Errors Alerts"
  s.description = "Lumos Errors Alerts"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails",       "~> 3.2.12"
  s.add_dependency "airbrake",    "~> 3.1.8"
  s.add_dependency "rollbar",     "~> 0.9.3"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec"
end