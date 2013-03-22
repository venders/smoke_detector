require 'watch_tower/engine'

module WatchTower

  def self.alert(exception, options = {})
    if controller = options.delete(:controller)
      options.reverse_merge!(
        request_data: controller.rollbar_request_data,
        person_data: controller.rollbar_person_data
      )
    end

    Rollbar.report_exception(exception, options.delete(:request_data), options.delete(:person_data))

    Airbrake.notify(exception, options)
  end

  def self.message(message, options = {})
    level = options.delete(:level) || 'info'
    Rollbar.report_message(message, level, options)

    Airbrake.notify(message, options)
  end

end
