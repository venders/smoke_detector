Watch Tower
=============

Lumos Error Reporting Gem


Installation
-------------

Add the following to your `Gemfile`:
```
gem 'watch_tower'
```
This assumes you're using Lumos Labs' gemfury account.

Then add the provider's gem to your gemfile. Watch Tower currently supports Rollbar and Airbrake. For example,
```
gem 'airbrake'
gem 'rollbar'
```

Finally, create an initializer file `config/initializers/watch_tower.rb`:
```
module WatchTower

  class Engine < Rails::Engine

    config.airbrake = {
      api_key: ENV['AIRBRAKE_KEY']
    }

    config.rollbar = {
      api_key: ENV['ROLLBAR_KEY']
    }

  end
end
```
Note: Only a subset of configuration parameters are currently available.


TODO
----

1. Add support for JS reporting snippets
2. Refactor provider configurations into plug-and-play classes
3. Add support for all configuration settings
4. Only allow one provider at a time (necessary for gem publication)
