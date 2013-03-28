require 'spec_helper'

describe WatchTower::Providers::Rollbar do
  let(:provider) { WatchTower::Providers::Rollbar.new('api_key', settings) }
  let(:settings) { {} }
  let(:err) { StandardError.new('error') }
  let(:data) { {custom: :data} }

  describe '#alert' do
    it 'reports the exception to Rollbar' do
      Rollbar.should_receive(:report_exception).with(err)
      provider.alert(err)
    end

    context 'when passed a controller option' do
      let(:request_data) { {request: :data} }
      let(:person_data) { {person: :data} }
      let(:controller) do
        mock('controller').tap do |c|
          c.stub_chain(:request, :env).and_return(mock('env'))
        end
      end

      before do
        provider.stub(:extract_request_data_from_rack).and_return(request_data)
        provider.stub(:extract_person_data_from_controller).and_return(person_data)
      end

      it 'includes the request_data and person_data' do
        Rollbar.should_receive(:report_exception).with(err, request_data, person_data)
        provider.alert(err, controller: controller)
      end
    end

    context 'when passed a data option' do
      it 'includes the data in the exception message' do
        err.message.should_receive(:<<).with(data.to_s)
        provider.alert(err, data: data)
      end
    end

  end

  describe '#message' do
    let(:message) { 'Hello Rollbar' }
    let(:level) { 'info' }
    let(:options) { {} }

    it 'reports the message to Rollbar' do
      Rollbar.should_receive(:report_message).with(message, level, options)
      provider.message(message)
    end

    context 'when passed options' do
      let(:options) { {custom: :data} }

      it 'passes the options along as the data param' do
        Rollbar.should_receive(:report_message).with(message, level, options)
        provider.message(message, options)
      end

      context 'including the level' do
        let(:level) { 'debug' }
        let(:options) { {custom: :data, level: level} }

        it 'sets the message level' do
          Rollbar.should_receive(:report_message).with(message, level, options)
          provider.message(message, options)
        end

        it 'does not include the level in the data param' do
          Rollbar.should_receive(:report_message).with(message, level, options)
          provider.message(message, options)
        end
      end
    end
  end
end
