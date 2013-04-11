module WatchTower
  class Engine < ::Rails::Engine

    config.providers = nil

    initializer 'watch_tower.init_error_handler' do
      config.providers.each do |provider|
        WatchTower.register_provider provider[:provider], provider[:api_key], provider[:settings]
      end

      ActiveSupport.on_load(:action_controller) do
        include WatchTower::ControllerMethods
      end
    end

    initializer 'watch_tower.add_middleware' do |app|
      app.middleware.use BrowserTracking
    end
  end
end
