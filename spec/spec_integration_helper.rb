$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require 'rspec/rails'
#require 'factory_girl_rails'

#require 'ud_sync'
#require 'awesome_print'

Rails.backtrace_cleaner.remove_silencers!

ActiveRecord::Migration.maintain_test_schema!

def json_response
  ActiveSupport::JSON.decode(response.body)
end

require 'spec_helper'
