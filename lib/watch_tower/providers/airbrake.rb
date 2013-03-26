module WatchTower::Providers
  class Airbrake < Provider

    def initialize(api_key, settings = {})
      ::Airbrake.configure do |c|
        c.api_key = api_key
        c.development_environments = settings[:development_environments] if settings[:development_environments]
      end
    end

    def alert(exception, options = {})
      ::Airbrake.notify(exception, options)
    end

    def message(message, options = {})
      ::Airbrake.notify(message, options)
    end

  end
end
