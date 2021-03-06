require 'spec_helper'

describe SmokeDetector::Providers::Airbrake do
  let(:provider) { SmokeDetector::Providers::Airbrake.new('api_key', nil, settings) }
  let(:settings) { {} }
  let(:err) { double('error', backtrace: [], message: 'bad news') }
  let(:data) { {custom: :data} }

  describe '#alert' do
    it 'notifies Airbrake of the exception' do
      Airbrake.should_receive(:notify).with(err)
      provider.alert(err)
    end

    context 'when passed a controller option' do
      it 'ignores the option' do
        Airbrake.should_receive(:notify).with(err)
        provider.alert(err, controller: double('controller'))
      end
    end

    context 'when passed a data option' do
      it 'includes the data in the Airbrake parameters' do
        Airbrake.should_receive(:notify).with(err, parameters: data)
        provider.alert(err, data: data)
      end
    end

  end

  describe '#message' do
    let(:message) { 'hello airbrake' }

    it 'notifies Airbrake of the message' do
      Airbrake.should_receive(:notify).with(message)
      provider.message(message)
    end

    context 'when passed options' do
      it 'includes the options in the Airbrake parameters' do
        Airbrake.should_receive(:notify).with(message, parameters: data)
        provider.message(message, data: data)
      end
    end
  end

  describe 'ControllerMethods' do
    let(:controller) do
      ActionController::Base.new.tap do |c|
        c.class.send(:include, SmokeDetector::Providers::Airbrake::ControllerMethods)
        c.stub(:rollbar_request_data)
        c.stub(:rollbar_person_data)
      end
    end

    describe '#alert_smoke_detector' do
      it 'notifies Airbrake of the exception' do
        controller.should_receive(:notify_airbrake)
        controller.alert_smoke_detector(err)
      end
    end
  end
end
