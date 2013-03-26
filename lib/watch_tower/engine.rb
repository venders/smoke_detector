module WatchTower
  class Engine < ::Rails::Engine

    config.provider = nil
    config.api_key = nil
    config.settings = nil

    initializer 'watch_tower.init_error_handler' do
      WatchTower.register_provider config.provider, config.api_key, config.settings
    end
  end
end
