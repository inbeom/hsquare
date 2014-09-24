require 'spec_helper'

RSpec.describe Hsquare::Notification do
  describe '#deliver' do
    let(:recipient_id) { 123 }
    let(:message) { 'message' }
    let(:notification) { Hsquare::Notification.new(recipient_id: recipient_id, message: message) }

    it do
      Hsquare.config.applications.each do |application|
        expect(application.admin_client).to receive(:post).with('/v1/push/send', body: { uuids: [recipient_id].to_json, push_message: { for_apns: { push_alert: true, message: message }, for_gcm: { delay_while_idle: false, custom_field: { message: message } } }.to_json })
      end

      notification.deliver
    end
  end

  describe '#recipient_id=' do
    let(:recipient_id) { 123 }
    let(:notification) { Hsquare::Notification.new }

    it { expect { notification.recipient_id = recipient_id }.to change { notification.recipient_ids }.to([recipient_id]) }
  end
end
