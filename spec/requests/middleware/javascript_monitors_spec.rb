require 'spec_helper'
require 'nokogiri'

describe SmokeDetector::JavaScriptMonitors do

  before do
    SmokeDetector.instance_variable_set(:@providers, [])
    # FIXME There is only one instance of the middleware class so the @monitoring_code instance
    #       variable is only set once on app init and there's no easy way to access that
    #       instance.
    ObjectSpace.each_object(SmokeDetector::JavaScriptMonitors) do |jsm|
      jsm.instance_variable_set(:@monitoring_code, nil)
    end
  end

  context 'with a Rollbar client API key configured' do
    before do
      SmokeDetector.register_provider(:rollbar, 'key', 'client_key')
    end

    it 'injects the Rollbar JS snippet into the <head>' do
      get '/widgets'
      expect(Nokogiri::HTML(response.body).css('head script:contains("_rollbarConfig")')).to_not be_empty
    end
  end

  context 'without a Rollbar client API key configured' do
    before do
      SmokeDetector.register_provider(:rollbar, 'key', nil)
    end

    it 'does not inject the Rollbar JS snippet into the <head>' do
      get '/widgets'
      expect(Nokogiri::HTML(response.body).css('head script:contains("_rollbarConfig")')).to be_empty
    end
  end

end
