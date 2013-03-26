require 'watch_tower/providers'
require 'watch_tower/engine'

module WatchTower

  # Reports an exception through WatchTower. Returns nil.
  #
  # @example
  #   begin
  #     foo = bar
  #   rescue => e
  #     WatchTower.alert(e)
  #   end
  #
  # @param exception [Exception] The exception object to report
  # @option options [ActionController] :controller The controller context
  # @option options [Hash] :data Additional data to include alongside the exception
  def self.alert(exception, options = {})
    self.provider.alert(exception, options)
    nil
  end

  # Records a message through WatchTower. Returns nil.
  #
  # @example
  #   WatchTower.message('Look out!')
  #
  # @param message [String] The message to be recorded
  # @option options [Hash] Additional data to include alongside the message
  def self.message(message, options = {})
    self.provider.message(message, options)
    nil
  end

end
