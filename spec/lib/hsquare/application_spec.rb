require 'spec_helper'

RSpec.describe Hsquare::Application do
  describe '#admin_client' do
    let(:application) { Hsquare::Application.new }

    context 'when admin key is set' do
      let(:admin_key) { 'admin-key' }
      let(:application) { Hsquare::Application.new admin_key: admin_key }

      it { expect(application.admin_client.default_options).not_to be_empty }
      it { expect(application.admin_client.default_options[:headers]).not_to be_empty }
      it { expect(application.admin_client.default_options[:headers]['Authorization']).to eq("KakaoAK #{admin_key}") }
    end

    context 'when base_uri is set' do
      let(:base_uri) { 'http://localhost:3000' }
      let(:application) { Hsquare::Application.new base_uri: base_uri }

      it { expect(application.admin_client.default_options).not_to be_empty }
      it { expect(application.admin_client.default_options[:base_uri]).to eq(base_uri) }
    end

    context 'when proxy is set' do
      let(:configuration) { Hsquare::Configuration.new.tap { |c| c.http_proxy = 'http://proxy.com:80' } }

      before { Hsquare.apply(configuration) }

      it { expect(application.admin_client.default_options).not_to be_empty }
      it { expect(application.admin_client.default_options[:http_proxyaddr]).to eq('proxy.com') }
    end
  end
end
