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
      before { configuration.admin_key = 'admin-key' }

      it { expect { Hsquare.apply(configuration) }.not_to change { Hsquare::Client.default_options } }
      it { expect { Hsquare.apply(configuration) }.to change { Hsquare::Client::Admin.admin_key } }
      it { expect { Hsquare.apply(configuration) }.to change { Hsquare::Client::Admin.default_options } }
    end
  end
end
