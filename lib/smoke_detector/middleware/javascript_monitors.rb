module SmokeDetector
  class JavaScriptMonitors

    TARGET_TAG = '<head>'
    ACCEPTABLE_CONTENT = /text\/html|application\/xhtml\+xml/

    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, response = @app.call(env)

      if monitor?(headers)
        body = response.body
        if index = body.rindex(TARGET_TAG) + TARGET_TAG.length + 1
          body.insert(index, tracking_code)
          headers["Content-Length"] = body.length.to_s
          response = [body]
        end
      end

      [status, headers, response]
    end

    private

    def tracking_code
      @tracking_code ||= SmokeDetector.providers.map(&:client_tracking_code).join('')
    end

    def monitor?(headers)
      headers["Content-Type"] =~ ACCEPTABLE_CONTENT && tracking_code.present?
    end
  end
end





