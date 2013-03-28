require 'spec_helper'

describe 'Multi-provider config: An exception' do

  before do
    WatchTower.instance_variable_set(:@providers, [])

    WatchTower.register_provider(:rollbar, 'key')
    WatchTower.register_provider(:airbrake, 'key')
    WatchTower.providers.size.should == 2
  end

  context 'uncaught in a controller' do
    it 'reports the error to Rollbar' do
      # TODO why is this firing twice in tests? once in ActionDispatch and once in Test Session
      Rollbar.should_receive(:report_exception).twice.and_return({})
      expect { get '/widgets/bubble_up' }.to raise_error(RuntimeError, 'bubble_up')
    end

    it 'reports the error to Airbrake' do
      Airbrake.should_receive(:notify_or_ignore)
      expect { get '/widgets/bubble_up' }.to raise_error(RuntimeError, 'bubble_up')
    end
  end

  context 'caught and reported in a controller' do
    it 'reports the error to Rollbar' do
      Rollbar.should_receive(:report_exception)
      expect { get '/widgets/catch' }.to_not raise_error(RuntimeError)
    end

    it 'reports the error to Airbrake' do
      Airbrake.should_receive(:notify)
      expect { get '/widgets/catch' }.to_not raise_error(RuntimeError)
    end
  end

  context 'uncaught in a model' do
    it 'reports the error to Rollbar' do
      # TODO why is this firing twice in tests? once in ActionDispatch and once in Test Session
      Rollbar.should_receive(:report_exception).twice.and_return({})
      expect { get '/widgets/deep_bubble_up' }.to raise_error(RuntimeError, 'deep_bubble_up')
    end

    it 'reports the error to Airbrake' do
      Airbrake.should_receive(:notify_or_ignore)
      expect { get '/widgets/deep_bubble_up' }.to raise_error(RuntimeError, 'deep_bubble_up')
    end
  end

  context 'caught and reported in a model' do
    it 'reports the error to Rollbar' do
      Rollbar.should_receive(:report_exception)
      expect { get '/widgets/deep_catch' }.to_not raise_error(RuntimeError)
    end

    it 'reports the error to Airbrake' do
      Airbrake.should_receive(:notify)
      expect { get '/widgets/deep_catch' }.to_not raise_error(RuntimeError)
    end
  end

end
