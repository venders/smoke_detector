module WatchTower::Providers

  class Rollbar < Provider

    def initialize(api_key, settings = {})
      super
      ::Rollbar.configure do |c|
        c.access_token = api_key
        c.person_username_method = settings[:person_username_method] if settings[:person_username_method].present?
        c.person_email_method = settings.rollbar[:person_email_method] if settings[:person_email_method].present?
        c.project_gems = settings[:project_gems] if settings[:project_gems]
        c.use_async = !!settings[:use_async]
      end
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

    def javascript_snippet
      <<-JS
        <script>var _rollbarParams = {"server.environment": "production"};_rollbarParams["notifier.snippet_version"] = "2"; var _rollbar=["#{api_key}", _rollbarParams]; var _ratchet=_rollbar;(function(w,d){w.onerror=function(e,u,l){_rollbar.push({_t:'uncaught',e:e,u:u,l:l});};var i=function(){var s=d.createElement("script");var f=d.getElementsByTagName("script")[0];s.src="//d37gvrvc0wt4s1.cloudfront.net/js/1/rollbar.min.js";s.async=!0;
f.parentNode.insertBefore(s,f);};if(w.addEventListener){w.addEventListener("load",i,!1);}else{w.attachEvent("onload",i);}})(window,document);
</script>
      JS
    end

    module ControllerMethods
      def alert_watch_tower(exception, options = {})
        super if defined?(super)

        if data = options.delete(:data)
          exception.message << data.to_s
        end

        ::Rollbar.report_exception(exception, rollbar_request_data, rollbar_person_data)
      end
    end
  end
end
