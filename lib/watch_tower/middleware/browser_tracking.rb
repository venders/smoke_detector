module WatchTower
  class BrowserTracking
    def initialize(app, options = {})
      @app = app
    end

    def call(env)
      status, headers, response = @app.call(env)

      source = ''
      response.each {|fragment| source << fragment.to_s}
      return nil unless source && source.size > 0

      if source[0..50_000].index('<body')
        beginning_of_head = source.index('<head')
        insertion_point = source.index('>', beginning_of_head) + 1
        snippets = WatchTower.providers.collect(&:javascript_snippet)
        source.insert(insertion_point, snippets.join)

        headers['Content-Length'] = source.length.to_s if headers['Content-Length']
        response = Rack::Response.new(source, status, headers)
        response.finish
      else
        [status, headers, response]
      end
    end
  end
end
