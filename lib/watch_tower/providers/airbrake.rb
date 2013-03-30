module WatchTower::Providers
  class Airbrake < Provider

    def initialize(api_key, settings = {})
      puts 'init AIRBRAKE'
      require 'airbrake'
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

  end
end
