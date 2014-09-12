require 'httparty'

require 'hsquare/version'
require 'hsquare/configuration'
require 'hsquare/client'
require 'hsquare/device'
require 'hsquare/notification'

module Hsquare
  # Public: Configures Hsquare with given block.
  #
  # Examples
  #
  #   Hsqure.config do |config|
  #     config.admin_key = # Admin key obtained from Kakao Developers
  #   end
  #
  # Returns newly set configuration.
  def self.config
    if block_given?
      Hsquare::Configuration.new.tap do |configuration|
        yield(configuration)
        apply(configuration)
      end
    else
      @configuration ||= Hsquare::Configuration.new
    end
  end

  # Public: Applies given configuration.
  #
  # Returns nothing.
  def self.apply(configuration)
    Hsquare::Client::Admin.admin_key = configuration.admin_key if configuration.admin_key

    if configuration.http_proxy
      http_proxy_uri = URI.parse(configuration.http_proxy)

      Hsquare::Client.http_proxy http_proxy_uri.host, http_proxy_uri.port
    end

    @configuration = configuration
  end
end
