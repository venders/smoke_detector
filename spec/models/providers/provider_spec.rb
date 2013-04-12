require 'spec_helper'

describe WatchTower::Providers::Provider do
  let(:api_key) { 'api_key' }
  let(:provider) { WatchTower::Providers::Provider.new(api_key) }

  describe '#alert' do
    subject { provider.alert(Exception.new) }

    it 'raises an error' do
      expect { subject }.to raise_error NotImplementedError
    end
  end

  describe '#message' do
    subject { provider.message(Exception.new) }

    it 'raises an error' do
      expect { subject }.to raise_error NotImplementedError
    end
  end

end
