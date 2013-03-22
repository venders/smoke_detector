require 'spec_helper'

describe 'An exception' do

  context 'uncaught in a controller' do
    it 'reports the error to Rollbar with request and person data' do
      # TODO add request and person data assertions
      # Note: rollbar re-raises exceptions in test environment
      Rollbar.should_receive(:report_exception).twice.and_return({})
      expect { get '/widgets/bubble_up' }.to raise_error(RuntimeError, 'bubble_up')
    end

    it 'reports the error to Airbrake'
  end

  context 'caught and reported in a controller' do
    it 'reports the error to Rollbar with request and person data' do
      # TODO add request and person data assertions
      Rollbar.should_receive(:report_exception)
      expect { get '/widgets/catch' }.to_not raise_error(RuntimeError)
    end

    it 'reports the error to Airbrake'
  end

  context 'uncaught in a model' do
    it 'reports the error to Rollbar' do
      # Note: rollbar re-raises exceptions in test environment
      Rollbar.should_receive(:report_exception).twice.and_return({})
      expect { get '/widgets/deep_bubble_up' }.to raise_error(RuntimeError, 'deep_bubble_up')
    end

    it 'reports the error to Airbrake'
  end

  context 'caught and reported in a model' do
    it 'reports the error to Rollbar' do
      Rollbar.should_receive(:report_exception)
      expect { get '/widgets/deep_catch' }.to_not raise_error(RuntimeError)
    end

    it 'reports the error to Airbrake'
  end

end
