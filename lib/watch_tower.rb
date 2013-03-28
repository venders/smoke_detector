require 'watch_tower/exceptions'
require 'watch_tower/providers'
require 'watch_tower/engine'

module WatchTower

  def self.alert(exception, options = {})
    self.providers.each {|provider| provider.alert(exception, options) }
    nil
  end

  def self.message(message, options = {})
    self.providers.each {|provider| provider.message(message, options) }
    nil
  end

end
