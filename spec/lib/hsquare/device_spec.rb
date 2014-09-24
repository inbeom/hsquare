require 'spec_helper'

RSpec.describe Hsquare::Device do
  let(:client) { Hsquare.config.default_application.admin_client }

  describe '.find_by_user_id' do
    let(:user_id) { 123 }
    let(:mock_response) { double(parsed_response: []) }

    it { expect(client).to receive(:get).with('/v1/push/tokens', query: { uuid: user_id }).and_return(mock_response); Hsquare::Device.find_by_user_id(user_id) }
  end

  describe '#initialize' do
    let(:attributes) { {} }
    let(:device) { Hsquare::Device.new(attributes) }

    context 'when attributes is set with proper values' do
      let(:attributes) { { id: 2, type: 'apns', user_id: 3, token: 'token' } }

      it { expect(device.id).to eq(attributes[:id]) }
      it { expect(device.type).to eq(attributes[:type]) }
      it { expect(device.user_id).to eq(attributes[:user_id]) }
      it { expect(device.token).to eq(attributes[:token]) }
    end

    context 'when attributes is set with values from API response' do
      let(:attributes) { { device_id: 2, push_type: 'apns', uuid: 3, push_token: 'token' } }

      it { expect(device.id).to eq(attributes[:device_id]) }
      it { expect(device.type).to eq(attributes[:push_type]) }
      it { expect(device.user_id).to eq(attributes[:uuid]) }
      it { expect(device.token).to eq(attributes[:push_token]) }
    end
  end

  describe '#register' do
    let(:attributes) { { id: 1, user_id: 2, type: 'apns', token: 'token' } }
    let(:device) { Hsquare::Device.new(attributes) }

    it { expect(client).to receive(:post).with('/v1/push/register', body: { uuid: device.user_id, device_id: device.id, push_type: device.type, push_token: device.token }); device.register }
  end

  describe '#unregister' do
    let(:attributes) { { id: 1, user_id: 2, type: 'apns', token: 'token' } }
    let(:device) { Hsquare::Device.new(attributes) }

    it { expect(client).to receive(:post).with('/v1/push/deregister', body: { uuid: device.user_id, device_id: device.id, push_type: device.type }); device.unregister }
  end
end
