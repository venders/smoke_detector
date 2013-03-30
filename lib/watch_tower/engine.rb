module WatchTower
  class Engine < ::Rails::Engine

    config.providers = nil

    initializer 'watch_tower.init_error_handler', :before=> :load_config_initializers do
      providers = YAML.load(File.read(Rails.root.join('config', 'watch_tower.yml')))[Rails.env]['providers']

      providers.each do |provider|
        provider.symbolize_keys!
        WatchTower.register_provider provider[:provider].to_sym, provider[:api_key], provider[:settings]
      end
    end
  end
end
