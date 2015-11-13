if ENV["COVERAGE"]
  exlist = Dir.glob([
    'db/**/*.rb',
    'spec/**/*.rb'
  ])

  require 'simplecov'
  require 'simplecov-rcov'
  SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
  SimpleCov.start do
    exlist.each do |p|
      add_filter p
    end
  end
end

# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

require File.expand_path('../dummy/config/environment.rb',  __FILE__)

require 'rspec/rails'
#require 'rspec/active_model/mocks'
require 'database_cleaner'
require 'ffaker'
require 'show_me_the_cookies'


# In case we have any coffeescript or sass files ...
# Do not forget to add following gems to Gemfile:
# gem 'coffee-rails'
# gem 'sass-rails', '~> 4.0.2'
# To stop these warnings:
# WARN: tilt autoloading 'sass' in a non thread-safe way; explicit require 'sass' suggested.
# WARN: tilt autoloading 'coffee_script' in a non thread-safe way; explicit require 'coffee_script' suggested.
# require 'coffee_script'
# require 'sass'


# In case we want to do capybara and selenium tests.
# Do not forget to add following gems to Gemfile:
# gem 'capybara'
# gem 'selenium-webdriver'
# gem poltergeist

# require 'capybara/rspec'
# require 'capybara/rails'
# require 'capybara-screenshot/rspec'
# require 'capybara/poltergeist'
# Capybara.javascript_driver = :poltergeist
# Capybara.default_max_wait_time = 15

Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |f| require f }

require 'spree/testing_support/factories'
require 'spree/testing_support/controller_requests'
require 'spree/testing_support/authorization_helpers'
require 'spree/testing_support/url_helpers'

FactoryGirl.find_definitions

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include Spree::TestingSupport::ControllerRequests, type: :controller
  config.include Spree::TestingSupport::UrlHelpers
  config.include Spree::TestingSupport::AuthorizationHelpers::Controller
  config.include ShowMeTheCookies, type: :feature


  config.mock_with :rspec
  config.color = true
  config.use_transactional_fixtures = false

  config.before :suite do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with :truncation
  end

  config.before do |example|
    DatabaseCleaner.strategy = example.metadata[:js] ? :truncation : :transaction
    DatabaseCleaner.start
  end

  config.after do
    DatabaseCleaner.clean
  end

  config.fail_fast = ENV['FAIL_FAST'] || false

  # rspec-rails 3 will no longer automatically infer an example group's spec type
  # from the file location. You can explicitly opt-in to the feature using this
  # config option.
  # To explicitly tag specs without using automatic inference, set the `:type`
  # metadata manually:
  #
  #     describe ThingsController, :type => :controller do
  #       # Equivalent to being in spec/controllers
  #     end
  config.infer_spec_type_from_file_location!
end