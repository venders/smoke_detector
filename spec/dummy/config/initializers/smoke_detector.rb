module SmokeDetector

  class Engine < Rails::Engine


    config.providers = [
      {
        provider: :rollbar,
        api_key: 'fake_rollbar',
        client_settings: {
          api_key: 'fake_rollbar_client'
        },
        settings: {
          use_async: true
        }
      },
      {
        provider: :airbrake,
        api_key: 'fake_airbrake',
        settings: {
          development_environments: []
        }
      }
    ]

  end
end
