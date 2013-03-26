module WatchTower

  class Engine < Rails::Engine

    config.provider = :rollbar
    config.api_key = 'fake_rollbar'
    config.settings = {
      use_async: true
    }

  end
end
