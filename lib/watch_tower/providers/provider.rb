module WatchTower::Providers

  class Provider
    def alert(exception, options = {})
      raise NotImplementedError
    end

    def message(message, options = {})
      raise NotImplementedError
    end
  end

end
