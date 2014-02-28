module SmokeDetector
  class JavaScriptMonitors

    TARGET_TAG = '<head>'

    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, response = @app.call(env)

      if headers["Content-Type"] =~ /text\/html|application\/xhtml\+xml/
        body = ''
        response.each { |part| body << part }
        index = body.rindex(TARGET_TAG) + TARGET_TAG.length + 1
        if index
          body.insert(index, JavaScriptMonitors.tracking_code)
          headers["Content-Length"] = body.length.to_s
          response = [body]
        end
      end

      [status, headers, response]
    end

    private

    def self.tracking_code
      @tracking_code ||= SmokeDetector.providers.inject("") { |acc, provider| acc << provider.client_tracking_code }
    end
  end
end





