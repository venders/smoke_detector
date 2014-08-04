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
      SmokeDetector.register_provider(:rollbar, 'key', {api_key: 'client_key' })
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

  context 'hostWhitelist' do
    before do
      SmokeDetector.register_provider(:rollbar, 'key', {api_key: 'client_key', host_whitelist: host_whitelist})
    end

    shared_examples "a properly set hostWhiteList" do
      it 'injects the Rollbar JS snippet into the <head>' do
        get '/widgets'
        rollbar_snippet = Nokogiri::HTML(response.body).css('head script:contains("_rollbarConfig")').children.first
        expect(rollbar_snippet).to_not be_nil
      end

      it 'sets hostWhitelist' do
        get '/widgets'
        script_content = Nokogiri::HTML(response.body).css('head script:contains("_rollbarConfig")').children.first
        position = /hostWhiteList:\s*#{Regexp.escape(host_whitelist.to_s)}/i =~ script_content
        expect(position).to_not be_nil
      end
    end

    context 'with hostWhitelist Rollbar client setting configured' do
      let(:host_whitelist) { ['example.com', 'facebook.com'] }
      it_behaves_like "a properly set hostWhiteList"
    end

    context 'with hostWhitelist Rollbar client setting unset' do
      let(:host_whitelist) { nil }
      it_behaves_like "a properly set hostWhiteList"
    end
  end

  context 'ignoredMessages' do
    before do
      SmokeDetector.register_provider(:rollbar, 'key', {api_key: 'client_key', ignored_messages: ignored_messages})
    end

    shared_examples "a properly set ignoredMessages" do
      it 'injects the Rollbar JS snippet into the <head> with ignoredMessages set' do
        get '/widgets'
        script_content = Nokogiri::HTML(response.body).css('head script:contains("_rollbarConfig")').children.first
        position = /ignoredMessages:\s*#{Regexp.escape(ignored_messages.to_s)}/i =~ script_content
        expect(position).to_not be_nil
      end
    end

    context "with ignoredMessages Rollbar client setting configured" do
      let(:ignored_messages) { ['Error: Llamas are actually pretty cool.', 'Exception: The jerkstore called, and they ran out of you.'] }
      it_behaves_like "a properly set ignoredMessages"
    end

    context 'with ignoredMessages Rollbar client setting unset' do
      let(:ignored_messages) { nil }
      it_behaves_like "a properly set ignoredMessages"
    end
  end
end
