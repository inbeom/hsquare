require 'spec_helper'

RSpec.describe Hsquare::Configuration do
  describe '#application' do
    let(:configuration) { Hsquare::Configuration.new }

    context 'when it is first invocation' do
      let(:admin_key) { 'adminkey' }

      it { configuration.application { |a| a.admin_key = admin_key }; expect(configuration.default_application.admin_key).to eq(admin_key) }
    end

    context 'when it is second invocation' do
      before { configuration.application { |a| a.admin_key = 'first' } }

      let(:label) { :second_application }
      let(:admin_key) { 'adminkey' }

      it { configuration.application(label) { |a| a.admin_key = admin_key }; expect(configuration.default_application.admin_key).not_to eq(admin_key) }
      it { configuration.application(label) { |a| a.admin_key = admin_key }; expect(configuration.applications.last.admin_key).to eq(admin_key) }
      it { configuration.application(label) { |a| a.admin_key = admin_key }; expect(configuration.applications.last.label).to eq(label) }
    end
  end
end
