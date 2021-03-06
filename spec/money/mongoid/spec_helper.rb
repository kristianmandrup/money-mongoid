require 'spec_helper'
require 'mongoid'
require 'money'

require 'money/mongoid/version_setup'

Mongoid.configure do |config|
  # Mongoid.logger.level = Logger::DEBUG
  # Moped.logger.level = Logger::DEBUG
  Mongoid::VersionSetup.configure config
end

if RUBY_VERSION >= '1.9.2'
  YAML::ENGINE.yamler = 'syck'
end

RSpec.configure do |config|
  # config.mock_with(:mocha)

  config.before(:each) do
    Mongoid.purge!
    # Mongoid.database.collections.each do |collection|
    #   unless collection.name =~ /^system\./
    #     collection.remove
    #   end
    # end
  end
end

# require 'money/mongoid/models/price'
# require 'money/mongoid/models/account'

# require 'money/shared/generic_account_ex'
