module Hsquare
  # Public: Configuration object for Hsquare.
  class Configuration
    # Public: HTTP proxy URI.
    attr_accessor :http_proxy

    # Public: Sets admin key for default application.
    #
    # admin_key - Admin key to set.
    #
    # Returns newly set admin key.
    def admin_key=(admin_key)
      default_application.admin_key = admin_key
    end

    # Public: Retrieves default application.
    #
    # Returns Hsquare::Application object for default application.
    def default_application
      if @default_application
        @default_application
      elsif @applications && !@applications.empty?
        @default_application ||= @applications.first
      else
        @default_application ||= Hsquare::Application.new
      end
    end

    # Public: Retrieves list of registered applications.
    #
    # Returns Array of registered applications.
    def applications
      @applications ||= [default_application]
    end

    # Public: Adds a new application.
    #
    # Returns nothing.
    def application(label = nil, &block)
      new_application = Hsquare::Application.new(label: label)

      @default_application ||= new_application
      applications.push(new_application) unless applications.include?(new_application)

      yield new_application
    end
  end
end
