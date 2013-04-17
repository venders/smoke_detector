require 'spec_helper'

describe SmokeDetector::Providers::Provider do
  let(:provider) { SmokeDetector::Providers::Provider.new }

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
