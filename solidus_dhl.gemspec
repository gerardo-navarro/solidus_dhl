$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "solidus_dhl/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "solidus_dhl"
  s.version     = SolidusDhl::VERSION
  s.authors     = ["Gerardo Navarro Suarez"]
  s.email       = ["gerardo.navarro@edeka.de"]
  s.homepage    = "https://github.com/gerardo-navarro/solidus_dhl"
  s.summary     = "Summary of SolidusDhl."
  s.description = "Description of SolidusDhl."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  # -------------------------------------------- Frontend --------------------------------------------

  # -------------------------------------------- Backend --------------------------------------------
  # s.add_dependency "solidus", "~> 1.0"
  s.add_dependency "solidus_core", "~> 1.0"
  s.add_dependency "solidus_backend", "~> 1.0"
  s.add_dependency "solidus_auth_devise", "~> 1.2"
  s.add_dependency "solidus_sample", "~> 1.0"
  s.add_dependency 'dhl-intraship'

  # -------------------------------------------- Deployment --------------------------------------------

  # -------------------------------------------- Development Utils --------------------------------------------

  # -------------------------------------------- Testing --------------------------------------------
  s.add_development_dependency 'rspec-rails', "~> 3.3"
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'factory_girl_rails'

  # -------------------------------------------- Utils --------------------------------------------
  s.add_dependency 'figaro', '~> 1.1.1'

end
