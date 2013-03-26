module WatchTower::Providers

  class Rollbar < Provider

    def initialize(api_key, settings = {})
      ::Rollbar.configure do |c|
        c.access_token = api_key
        c.person_username_method = settings[:person_username_method] if settings[:person_username_method].present?
        c.person_email_method = settings.rollbar[:person_email_method] if settings[:person_email_method].present?
        c.project_gems = settings[:project_gems] if settings[:project_gems]
        c.use_async = !!settings[:use_async]
      end
    end


    def alert(exception, options = {})
      if controller = options.delete(:controller) &&
         controller.respond_to?(:rollbar_request_data) &&
         controller.respond_to?(:rollbar_person_data)

        options.reverse_merge!(
          request_data: controller.rollbar_request_data,
          person_data: controller.rollbar_person_data
        )
      end

      ::Rollbar.report_exception(exception, options.delete(:request_data), options.delete(:person_data))
    end

    def message(message, options = {})
      level = options.delete(:level) || 'info'
      ::Rollbar.report_message(message, level, options)
    end

  end

end
