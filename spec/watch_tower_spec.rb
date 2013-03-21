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
      let(:request_data) { nil }
      let(:person_data) { nil }
      let(:args) { [err] }

      it 'notifies Rollbar of the exception' do
        Rollbar.should_receive(:report_exception).once.with(err, request_data, person_data)
        alert_watch_tower
      end

      it 'notifies Airbrake of the exception' do
        Airbrake.should_receive(:notify).once.with(err, {})
        alert_watch_tower
      end

      context 'and a controller option' do
        let(:controller) do
          mock(:controller, rollbar_request_data: request_data, rollbar_person_data: person_data)
        end
        let(:args) { [err, controller: controller] }

        it 'notifies Rollbar of the exception with the request and person data' do
          Rollbar.should_receive(:report_exception).once.with(err, request_data, person_data)
          alert_watch_tower
        end

        it 'notifies Airbrake of the exception' do
          Airbrake.should_receive(:notify).once.with(err, {})
          alert_watch_tower
        end
      end

      context 'and request_data/person_data options' do
        let(:args) { [err, request_data: request_data, person_data: person_data] }

        it 'notifies Rollbar of the exception with the request and person data' do
          Rollbar.should_receive(:report_exception).once.with(err, request_data, person_data)
          alert_watch_tower
        end

        it 'notifies Airbrake of the exception' do
          Airbrake.should_receive(:notify).once.with(err, {})
          alert_watch_tower
        end
      end

      context 'and an api_key option' do
        let(:api_key) { 'airbrake_api_key' }
        let(:request_data) { nil }
        let(:person_data) { nil }
        let(:args) { [err, api_key: api_key] }

        it 'notifies Rollbar of the exception' do
          Rollbar.should_receive(:report_exception).once.with(err, request_data, person_data)
          alert_watch_tower
        end

        it 'notifies Airbrake of the exception passing the api_ley' do
          Airbrake.should_receive(:notify).once.with(err, {api_key: api_key})
          alert_watch_tower
        end
      end
    end
  end

  describe '.message' do
    let(:message) { "holy shit!" }

    def message_watch_tower
      WatchTower.message(*args)
    end

    context 'given a message' do
      let(:args) { [message] }

      it 'notifies Rollbar of the message' do
        Rollbar.should_receive(:report_message).once.with(message, 'info', {})
        message_watch_tower
      end

      it 'notifies Airbrake of the message' do
        Airbrake.should_receive(:notify).once.with(message, {})
        message_watch_tower
      end

      context 'and a level' do
        let(:level) { 'debug' }
        let(:args) { [message, level: level]}

        it 'notifies Rollbar of the message' do
          Rollbar.should_receive(:report_message).once.with(message, level, {})
          message_watch_tower
        end

        it 'notifies Airbrake of the message' do
          Airbrake.should_receive(:notify).once.with(message, {})
          message_watch_tower
        end
      end

      context 'and an api_key option' do
        let(:api_key) { 'airbrake_api_key' }
        let(:args) { [message, api_key: api_key] }

        it 'notifies Rollbar of the message' do
          Rollbar.should_receive(:report_message).once.with(message, 'info', {api_key: api_key})
          message_watch_tower
        end

        it 'notifies Airbrake of the message passing the api_ley' do
          Airbrake.should_receive(:notify).once.with(message, {api_key: api_key})
          message_watch_tower
        end
      end
    end
  end
end
