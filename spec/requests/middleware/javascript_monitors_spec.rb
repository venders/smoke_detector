require 'spec_helper'
require 'nokogiri'
require 'jshintrb'

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

  shared_examples "a page with a valid rollbar json config" do
    it "has no errors" do
      get '/widgets'
      content = Nokogiri::HTML(response.body).css('head script:contains("_rollbarConfig")').children.first.to_s
      errors  = Jshintrb.lint(content)
      expect(errors).to be_empty
    end
  end

  context 'with a Rollbar client API key configured' do
    before do
      SmokeDetector.register_provider(:rollbar, 'key', { api_key: 'client_key' })
    end

    it 'injects the Rollbar JS snippet into the <head>' do
      get '/widgets'
      expect(Nokogiri::HTML(response.body).css('head script:contains("_rollbarConfig")')).to_not be_empty
    end

    it "translates api_key to accessToken" do
      get '/widgets'
      rollbar_snippet = Nokogiri::HTML(response.body).css('head script:contains("_rollbarConfig")').children.first
      position        =  /"accessToken":"client_key"/
      expect(position).to_not be_nil
    end

    it_behaves_like "a page with a valid rollbar json config"
  end

  context 'without a Rollbar client API key configured' do
    before do
      SmokeDetector.register_provider(:rollbar, 'key', nil)
    end

    it 'does not inject the Rollbar JS snippet into the <head>' do
      get '/widgets'
      expect(Nokogiri::HTML(response.body).css('head script:contains("_rollbarConfig")')).to be_empty
    end

    it_behaves_like "a page with a valid rollbar json config"
  end

  context 'hostWhitelist' do
    before do
      SmokeDetector.register_provider(:rollbar, 'key', { api_key: 'client_key', hostWhiteList: host_whitelist })
    end

    shared_examples "a properly set hostWhiteList" do
      it 'injects the Rollbar JS snippet into the <head>' do
        get '/widgets'
        rollbar_snippet = Nokogiri::HTML(response.body).css('head script:contains("_rollbarConfig")').children.first.to_s
        expect(rollbar_snippet).to_not be_nil
      end

      it 'sets hostWhitelist' do
        get '/widgets'
        script_content = Nokogiri::HTML(response.body).css('head script:contains("_rollbarConfig")').children.first.to_s
        position = /\"hostWhiteList\":#{Regexp.escape(host_whitelist.to_json)}/i =~ script_content
        expect(position).to_not be_nil
      end

      it_behaves_like "a page with a valid rollbar json config"
    end

    context 'with hostWhitelist Rollbar client setting configured' do
      let(:host_whitelist) { ["example.com", "facebook.com"] }
      it_behaves_like "a properly set hostWhiteList"
    end

    context 'with hostWhitelist Rollbar client setting unset' do
      let(:host_whitelist) { nil }
      it_behaves_like "a properly set hostWhiteList"
    end
  end

  context 'ignoredMessages' do
    before do
      SmokeDetector.register_provider(:rollbar, 'key', {api_key: 'client_key', ignoredMessages: ignored_messages})
    end

    shared_examples "a properly set ignoredMessages" do
      it 'injects the Rollbar JS snippet into the <head> with ignoredMessages set' do
        get '/widgets'
        script_content = Nokogiri::HTML(response.body).css('head script:contains("_rollbarConfig")').children.first.to_s
        position = /\"ignoredMessages\":#{Regexp.escape(ignored_messages.to_json)}/i =~ script_content
        expect(position).to_not be_nil
      end

      it_behaves_like "a page with a valid rollbar json config"
    end

    context "with ignoredMessages Rollbar client setting configured" do
      let(:ignored_messages) { ["Error: Llamas are actually pretty cool.", "Exception: The jerkstore called, and they ran out of you."] }
      it_behaves_like "a properly set ignoredMessages"
    end

    context 'with ignoredMessages Rollbar client setting unset' do
      let(:ignored_messages) { nil }
      it_behaves_like "a properly set ignoredMessages"
    end
  end


end
