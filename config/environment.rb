# Load the rails application
#ENV['RAILS_ENV'] ||= 'production'
require File.expand_path('../application', __FILE__)

# Initialize the rails application
RailsFcgi::Application.initialize!
