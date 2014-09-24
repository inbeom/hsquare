require 'httparty'

require 'hsquare/version'
require 'hsquare/application'
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
    if configuration.http_proxy
      http_proxy_uri = URI.parse(configuration.http_proxy)

      Hsquare::Client.http_proxy http_proxy_uri.host, http_proxy_uri.port
    end

    configuration.applications.each(&:refresh_admin_client)

    @configuration = configuration
  end

  # Public: Finds application with given label.
  #
  # label - Label of the applcation.
  #
  # Returns registered Hsquare::Application object.
  def self.application(label = nil)
    if label
      @configuration.applications.detect { |application| application.label == label.to_sym }
    else
      @configuration.default_application
    end
  end
end
