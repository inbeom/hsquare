module Hsquare
  # Public: Notification entries sent to Kakao push.
  class Notification
    # Public: Array of recipient IDs.
    attr_accessor :recipient_ids

    # Public: Message (alert in APNS) displayed to recipients.
    attr_accessor :message

    # Public: Badge count to set.
    attr_accessor :badge

    # Public: Sound to play.
    attr_accessor :sound

    # Public: Whether notification is delivered through notification center.
    attr_accessor :push_alert

    # Public: Collapse key for GCM.
    attr_accessor :collapse

    # Public: Whether GCM message delivery is delayed while device is idle.
    attr_accessor :idle_delay

    # Public: Extra payload.
    attr_accessor :extra

    # Public: IDs of Hsquare applications to deliver.
    attr_accessor :app_ids

    # Public: Initializes new notification object.
    #
    # attributes - Attributes of the notification.
    #              :recipient_id  - ID of recipient (optinoal).
    #              :recipient_ids - List of IDs of recipients (optinoal).
    #              :message       - Message displayed to recipients (optional).
    #              :badge         - Badge count (optinoal).
    #              :sound         - Sound to play (optinoal).
    #              :push_alert    - Whether notification is delivered through
    #                               notification center (default: true).
    #              :collapse      - Collapse key for GCM (optional).
    #              :idle_delay    - Whether GCM message delivery is delayed
    #                               while device is idle (default: false).
    #              :extra         - Extra payload (optinoal).
    #              :app_ids       - IDs of Hsquare applications to deliver.
    #
    # Returns newly initialized notification object.
    def initialize(attributes = {})
      @recipient_ids = (attributes[:recipient_id] && [attributes[:recipient_id]]) || attributes[:recipient_ids]
      @message = attributes[:message]
      @badge = attributes[:badge]
      @sound = attributes[:sound]
      @push_alert = attributes.has_key?(:push_alert) ? attributes[:push_alert] : true
      @collapse = attributes[:collapse]
      @idle_delay = attributes.has_key?(:idle_delay) ? attributes[:idle_delay] : false
      @extra = attributes[:extra]
      @app_ids = attributes[:app_ids]
    end

    # Public: Helper method to set recipient_ids with single ID.
    #
    # recipient_id - ID of single recipient.
    #
    # Returns 1-length array of recipient_id.
    def recipient_id=(recipient_id)
      @recipient_ids = [recipient_id]
    end

    # Public: Delivers notification to recipients' devices.
    #
    # Returns nothing.
    def deliver
      Hsquare.config.applications.each do |application|
        if !app_ids || app_ids.include?(application.label)
          application.admin_client.post('/v1/push/send', body: payload)
        end
      end
    end

    protected

    # Internal: Payload delivered to push send API.
    #
    # Returns Hash of request body.
    def payload
      { uuids: recipient_ids.to_json, push_message: { for_apns: apns_payload, for_gcm: gcm_payload }.to_json }
    end

    # Internal: Payload for APNS.
    #
    # Returns Hash of APNS payload.
    def apns_payload
      {
        badge: badge,
        sound: sound,
        push_alert: push_alert,
        message: message,
        custom_field: extra
      }.keep_if { |_, v| !v.nil? }
    end

    # Internal: Payload for GCM.
    #
    # Returns Hash of GCM payload.
    def gcm_payload
      {
        collapse: collapse,
        delay_while_idle: idle_delay,
        custom_field: (extra || {}).merge(message: message)
      }.keep_if { |_, v| !v.nil? }
    end
  end
end
