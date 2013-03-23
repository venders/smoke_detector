module WatchTower

  class Engine < Rails::Engine

    config.airbrake = {
      api_key: "fake_airbrake",
      development_environments: []
    }

    config.rollbar = {
      api_key: "fake_rollbar",
      use_async: true
    }

  end
end
