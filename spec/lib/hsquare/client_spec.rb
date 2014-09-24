require 'spec_helper'

RSpec.describe Hsquare::Client do
  describe Hsquare::Client::Admin do
    describe '#admin_key=' do
      let(:admin_key) { 'admin-key' }

      before { Hsquare::Client::Admin.admin_key = nil }

      it { expect { Hsquare::Client::Admin.admin_key = admin_key }.to change { Hsquare::Client::Admin.default_options } }
      it { expect { Hsquare::Client::Admin.admin_key = admin_key }.not_to change { Hsquare::Client.default_options } }
    end
  end
end
