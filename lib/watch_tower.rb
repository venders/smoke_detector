module WatchTower

  def self.alert(exception, options = {})
    puts exception.message
  end

  def self.message(message, options = {})
    puts message
  end

end
