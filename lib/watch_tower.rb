require 'watch_tower/engine'

module WatchTower

  def self.alert(exception, options = {})
    Rollbar.report_exception(exception, options)
  end

  def self.message(message, options = {})
    Rollbar.report_message(message, options)
  end

end
