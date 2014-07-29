module SmokeDetector::Providers

  class Rollbar < Provider

    attr_accessor :client_host_whitelist, :client_ignore_partial_messages

    def initialize(api_key, client_settings = {}, settings = {})
      super
      ::Rollbar.configure do |c|
        c.environment = ::Rails.env # Rollbar sets this to 'unspecified' by default

        c.access_token = api_key
        apply_configuration_settings(c, settings)

        # set Rollbar defaults
        c.logger ||= ::Rails.logger
        c.root ||= ::Rails.root
        c.framework = "Rails: #{::Rails::VERSION::STRING}"
        c.filepath ||= ::Rails.application.class.parent_name + '.rollbar'
      end

      @client_host_whitelist  = @client_settings[:host_whitelist] || []
      @client_ignore_messages = @client_settings[:ignored_messages] || []
    end

    def alert(exception, options = {})
      if data = options.delete(:data)
        exception.message << data.to_s
      end

      ::Rollbar.report_exception(exception)
    end

    def message(message, options = {})
      level = options.delete(:level) || 'info'
      ::Rollbar.report_message(message, level, options)
    end

    def client_monitoring_code
      return '' if client_api_key.blank?
      @client_monitoring_code ||= <<-JS
        <script>
          var _rollbarConfig = {
              accessToken: "#{@client_api_key}",
              captureUncaught: true,
              payload: {
                  environment: "#{::Rails.env}"
              },
              hostWhiteList: #{@client_host_whitelist.to_s},
              ignoredMessages: #{@client_ignored_messages.to_s}
          };
          !function(a,b){function c(b){this.shimId=++h,this.notifier=null,this.parentShim=b,this.logger=function(){},a.console&&void 0===a.console.shimId&&(this.logger=a.console.log)}function d(b,c,d){!d[4]&&a._rollbarWrappedError&&(d[4]=a._rollbarWrappedError,a._rollbarWrappedError=null),b.uncaughtError.apply(b,d),c&&c.apply(a,d)}function e(b){var d=c;return g(function(){if(this.notifier)return this.notifier[b].apply(this.notifier,arguments);var c=this,e="scope"===b;e&&(c=new d(this));var f=Array.prototype.slice.call(arguments,0),g={shim:c,method:b,args:f,ts:new Date};return a._rollbarShimQueue.push(g),e?c:void 0})}function f(a,b){if(b.hasOwnProperty&&b.hasOwnProperty("addEventListener")){var c=b.addEventListener;b.addEventListener=function(b,d,e){c.call(this,b,a.wrap(d),e)};var d=b.removeEventListener;b.removeEventListener=function(a,b,c){d.call(this,a,b?b._wrapped:b,c)}}}function g(a,b){return b=b||this.logger,function(){try{return a.apply(this,arguments)}catch(c){b("Rollbar internal error:",c)}}}var h=0;c.init=function(a,b){var e=b.globalAlias||"Rollbar";if("object"==typeof a[e])return a[e];a._rollbarShimQueue=[],a._rollbarWrappedError=null,b=b||{};var h=new c;return g(function(){if(h.configure(b),b.captureUncaught){var c=a.onerror;a.onerror=function(){var a=Array.prototype.slice.call(arguments,0);d(h,c,a)};var g,i,j=["EventTarget","Window","Node","ApplicationCache","AudioTrackList","ChannelMergerNode","CryptoOperation","EventSource","FileReader","HTMLUnknownElement","IDBDatabase","IDBRequest","IDBTransaction","KeyOperation","MediaController","MessagePort","ModalWindow","Notification","SVGElementInstance","Screen","TextTrack","TextTrackCue","TextTrackList","WebSocket","WebSocketWorker","Worker","XMLHttpRequest","XMLHttpRequestEventTarget","XMLHttpRequestUpload"];for(g=0;g<j.length;++g)i=j[g],a[i]&&a[i].prototype&&f(h,a[i].prototype)}return a[e]=h,h},h.logger)()},c.prototype.loadFull=function(a,b,c,d){var e=g(function(){var a=b.createElement("script"),e=b.getElementsByTagName("script")[0];a.src=d.rollbarJsUrl,a.async=!c,a.onload=f,e.parentNode.insertBefore(a,e)},this.logger),f=g(function(){if(void 0===a._rollbarPayloadQueue)for(var b,c,d,e,f=new Error("rollbar.js did not load");b=a._rollbarShimQueue.shift();)for(d=b.args,e=0;e<d.length;++e)if(c=d[e],"function"==typeof c){c(f);break}},this.logger);g(function(){c?e():a.addEventListener?a.addEventListener("load",e,!1):a.attachEvent("onload",e)},this.logger)()},c.prototype.wrap=function(b){try{if("function"!=typeof b)return b;if(b._isWrap)return b;if(!b._wrapped){b._wrapped=function(){try{return b.apply(this,arguments)}catch(c){throw a._rollbarWrappedError=c,c}},b._wrapped._isWrap=!0;for(var c in b)b.hasOwnProperty(c)&&(b._wrapped[c]=b[c])}return b._wrapped}catch(d){return b}};for(var i="log,debug,info,warn,warning,error,critical,global,configure,scope,uncaughtError".split(","),j=0;j<i.length;++j)c.prototype[i[j]]=e(i[j]);var k="//d37gvrvc0wt4s1.cloudfront.net/js/v1.1/rollbar.min.js";_rollbarConfig.rollbarJsUrl=_rollbarConfig.rollbarJsUrl||k;var l=c.init(a,_rollbarConfig);l.loadFull(a,b,!1,_rollbarConfig)}(window,document);
        </script>
      JS
    end

    module ControllerMethods
      def alert_smoke_detector(exception, options = {})
        super if defined?(super)

        if data = options.delete(:data)
          exception.message << data.to_s
        end

        ::Rollbar.report_exception(exception, rollbar_request_data, rollbar_person_data)
      end
    end
  end
end
