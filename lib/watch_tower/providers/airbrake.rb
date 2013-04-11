module WatchTower::Providers
  class Airbrake < Provider

    def initialize(api_key, settings = {})
      super
      ::Airbrake.configure do |c|
        c.api_key = api_key
        c.development_environments = settings[:development_environments] if settings[:development_environments]
      end
    end

    def alert(exception, options = {})
      options.delete(:controller)
      message(exception, options)
    end

    def message(message, options = {})
      args = [message]
      args << {parameters: options[:data]} if options[:data].present?
      ::Airbrake.notify(*args)
    end

    def javascript_snippet
      <<-JS
        <script type="text/javascript">
          //<![CDATA[
          var notifierJsScheme = (("https:" == document.location.protocol) ? "https://" : "http://");
          document.write(unescape("%3Cscript src='" + notifierJsScheme + "airbrake.io/javascripts/notifier.js' type='text/javascript'%3E%3C/script%3E"));
          //]]>
        </script>

        <script type="text/javascript">
          Hoptoad.setKey('#{api_key}');
          Hoptoad.setHost('api.airbrake.io');
          Hoptoad.setEnvironment('production');
            Hoptoad.setErrorDefaults({
              url: "http://example.com/pages/home",
              component: "pages",
              action: "show"
          });
        </script>
      JS
    end

    module ControllerMethods
      def alert_watch_tower(exception, options = {})
        super if defined?(super)

        notify_airbrake(exception)
      end
    end
  end
end
