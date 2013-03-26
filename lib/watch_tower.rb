require 'watch_tower/providers'
require 'watch_tower/engine'

module WatchTower

  def self.alert(exception, options = {})
    self.provider.alert(exception, options)
    nil
  end

  def self.message(message, options = {})
    self.provider.message(message, options)
    nil
  end

end
