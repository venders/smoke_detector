require 'spec_helper'

describe WatchTower do
  describe '.alert' do
    let(:err) { Exception.new }
    let(:request_data) { {request: 'data'} }
    let(:person_data) { {person: 'data'} }

    def alert_watch_tower
      WatchTower.alert(*args)
    end

    context 'given an exception' do
      let(:args) { [err] }

      it 'notifies the provider of the exception' do
        WatchTower.provider.should_receive(:alert).once.with(err, {})
        WatchTower.alert(err)
      end
    end
  end

  describe '.message' do
    let(:message) { "holy shit!" }

    context 'given a message' do
      let(:args) { [message] }

      it 'notifies the provider of the message' do
        WatchTower.provider.should_receive(:message).once.with(message, {})
        WatchTower.message(message)
      end
    end
  end
end
