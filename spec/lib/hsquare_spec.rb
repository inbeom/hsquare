require 'spec_helper'

RSpec.describe Hsquare do
  describe '.apply' do
    let(:configuration) { Hsquare::Configuration.new }

    before { Hsquare::Client.default_options.clear }
    before { Hsquare::Client::Admin.default_options.clear }

    context 'when http_proxy is set' do
      before { configuration.http_proxy = 'http://proxy.com:1234' }

      it { expect { Hsquare.apply(configuration) }.to change { Hsquare::Client.default_options } }
      it { expect { Hsquare.apply(configuration) }.to change { Hsquare::Client::Admin.default_options } }
    end

    context 'when admin_key is set' do
      before { Hsquare.apply(configuration) }
      before { configuration.admin_key = 'admin-key' }

      it { expect { Hsquare.apply(configuration) }.not_to change { Hsquare::Client.default_options } }
      it { expect { Hsquare.apply(configuration) }.not_to change { Hsquare::Client::Admin.default_options } }
      it { expect { Hsquare.apply(configuration) }.to change { Hsquare.config.default_application.admin_client.default_options } }
    end
  end

  describe '.application' do
    let(:configuration) { Hsquare::Configuration.new }

    before { configuration.application(:first) { |a| a.admin_key = 'firstkey' } }
    before { configuration.application(:second) { |a| a.admin_key = 'secondkey' } }
    before { Hsquare.apply(configuration) }

    it { expect(Hsquare.application(:first)).not_to be_nil }
    it { expect(Hsquare.application(:first).admin_key).to eq('firstkey') }
    it { expect(Hsquare.application(:second)).not_to be_nil }
    it { expect(Hsquare.application(:second).admin_key).to eq('secondkey') }
    it { expect(Hsquare.application(:third)).to eq(Hsquare.application(:first)) }
    it { expect(Hsquare.application).not_to be_nil }
    it { expect(Hsquare.application.label).to eq(:first) }
    it { expect(Hsquare.application.admin_key).to eq('firstkey') }
  end
end
