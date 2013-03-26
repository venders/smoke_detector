require 'active_support/inflector'

module WatchTower
  PROVIDERS = [
    :airbrake,
    :rollbar
  ]

  mattr_accessor :provider

  def self.register_provider(provider_name, api_key, settings = {})
    return @@provider if @@provider
    raise 'Unkown Provider' unless PROVIDERS.include?(provider_name)
    klass = ::ActiveSupport::Inflector.constantize("WatchTower::Providers::#{provider_name.capitalize}")
    @@provider = klass.new(api_key, settings)
  end
end

require 'watch_tower/providers/provider'
WatchTower::PROVIDERS.each do |provider|
  require "watch_tower/providers/#{provider}"
end
