module WatchTower
  class Engine < ::Rails::Engine

    config.airbrake = nil
    config.rollbar = nil

    initializer 'watch_tower.init_error_handlers' do

      if config.airbrake.present?
        require 'airbrake'
        Airbrake.configure do |c|
          c.api_key = config.airbrake[:api_key]
          c.development_environments = config.airbrake[:development_environments] if config.airbrake[:development_environments]
        end
      end

       if config.rollbar.present?
        require 'rollbar/rails'
        Rollbar.configure do |c|
          c.access_token = config.rollbar[:api_key]
          c.person_username_method = config.rollbar[:person_username_method] if config.rollbar[:person_username_method].present?
          c.person_email_method = config.rollbar[:person_email_method] if config.rollbar[:person_email_method].present?
          c.project_gems = config.rollbar[:project_gems] if config.rollbar[:project_gems]
          c.use_async = !!config.rollbar[:use_async]
        end
      end
    end
  end
end
