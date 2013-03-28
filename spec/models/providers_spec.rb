require 'spec_helper'

#FIXME This spec is dependent on global provider settings but should be mocked out better and each method should be unit tested
describe WatchTower do

  describe '.register_provider' do
    let(:api_key) { 'some_key' }

    context 'with a supported provider' do
      let(:provider) { :airbrake }

      context 'that is unregistered' do
        before do
          WatchTower.registered_provider?(:airbrake).should == false
        end

        it 'adds the provider to the WatchTower providers' do
          WatchTower.register_provider(provider, api_key)
          WatchTower.providers.last.should be_a WatchTower::Providers::Airbrake
        end
      end

      context 'that is registered' do
        let(:provider) { :rollbar }

        before do
          WatchTower.registered_provider?(provider).should == true
        end

        it 'raises an error' do
          expect { WatchTower.register_provider(provider, api_key) }.to raise_error WatchTower::ProviderRegistrationError
        end
      end

    end

    context 'with an unsupported provider' do
      let(:provider) { :not_a_provider }

      it 'raises an error' do
        expect { WatchTower.register_provider(provider, api_key) }.to raise_error WatchTower::ProviderRegistrationError
      end
    end
  end

end
