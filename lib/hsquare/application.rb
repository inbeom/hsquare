module Hsquare
  # Public: Application registered on developers.kakao.com
  class Application
    # Public: Distinctive label of the application.
    attr_accessor :label

    # Public: Admin access key of the application.
    attr_accessor :admin_key

    # Public: Initializes new application object.
    #
    # attributes - Attributes for the new application.
    #              :label     - Label of the application.
    #              :admin_key - Admin API key for the application.
    #
    # Returns newly initialized application object.
    def initialize(attributes = {})
      @label = attributes[:label]
      @admin_key = attributes[:admin_key]
    end

    # Public: Client with admin key associated with the application.
    #
    # Returns client class for the application inherits Hsquare::Client.
    def admin_client
      @admin_client ||= Class.new(Hsquare::Client::Admin).tap do |klass|
        klass.admin_key = admin_key if admin_key
      end
    end

    # Public: Clears previously cached admin client.
    #
    # Returns newly created admin client.
    def refresh_admin_client
      @admin_client = nil

      admin_client
    end
  end
end
