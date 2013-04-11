module WatchTower::Providers

  class Provider
    attr_accessor :api_key

    def initialize(api_key, settings = {})
      self.api_key = api_key
    end

    def alert(exception, options = {})
      raise NotImplementedError
    end

    def message(message, options = {})
      raise NotImplementedError
    end

    def javascript_snippet
      ''
    end
  end

end
