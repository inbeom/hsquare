module Hsquare
  # Public: APNS/GCM devices with push tokens.
  class Device
    # Public: ID of the device.
    attr_accessor :id

    # Public: ID of owner of the device.
    attr_accessor :user_id

    # Public: Push token received from service providers.
    attr_accessor :token

    # Public: Type of the device.
    attr_accessor :type

    # Public: Fetch devices for given user.
    #
    # user_or_user_id - User or ID of user.
    #
    # Returns Array of HSquare::Device objects retrieved from the server.
    def self.find_by_user_id(user_or_user_id)
      user_id = user_or_user_id.respond_to?(:id) ? user_or_user_id.id : user_or_user_id
      response = Hsquare::Client::Admin.get('/v1/push/tokens', query: { uuid: user_id })

      response.parsed_response.map do |device_response|
        new(device_response.symbolize_keys)
      end
    end

    # Public: Initializes new APNS type device.
    #
    # attributes - Attributes of the device.
    #              :id, :device_id     - ID of the device.
    #              :user_id, :uuid     - ID of the owner.
    #              :token, :push_token - Push token of the device.
    #
    # Returns newly initialized APNS device.
    def self.apns(attributes = {})
      new(attributes.merge(type: 'apns'))
    end

    # Public: Initializes new GCM type device.
    #
    # attributes - Attributes of the device.
    #              :id, :device_id     - ID of the device.
    #              :user_id, :uuid     - ID of the owner.
    #              :token, :push_token - Push token of the device.
    #
    # Returns newly initialized APNS device.
    def self.gcm(attributes = {})
      new(attributes.merge(type: 'gcm'))
    end

    # Public: Initializes new device object.
    #
    # attributes - Attributes of the device.
    #              :id, :device_id     - ID of the device.
    #              :type, :push_type   - Type of the device.
    #              :user_id, :uuid     - ID of the owner.
    #              :token, :push_token - Push token of the device.
    #
    # Returns newly iniitalized device object.
    def initialize(attributes = {})
      @id = attributes[:id] || attributes[:device_id]
      @user_id = attributes[:user_id] || attributes[:uuid]
      @token = attributes[:token] || attributes[:push_token]
      @type = attributes[:type] || attributes[:push_type]
    end

    # Public: Registers the device via Kakao API.
    #
    # Returns Number of days before invalidation.
    def register
      Hsquare::Client::Admin.post('/v1/push/register', body: {
        uuid: user_id, device_id: id, push_type: type, push_token: token
      })
    end

    # Public: Unregisters the device via Kakao API.
    #
    # Returns Number of days before invalidation.
    def unregister
      Hsquare::Client::Admin.post('/v1/push/deregister', body: {
        uuid: user_id, device_id: id, push_type: type
      })
    end
  end
end
