class WidgetsController < ApplicationController

  def index

    raise 'bad news'
  rescue
    WatchTower.alert($!)
  end

end
