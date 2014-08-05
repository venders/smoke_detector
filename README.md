[![Build Status](https://travis-ci.org/lumoslabs/smoke_detector.png)](https://travis-ci.org/lumoslabs/smoke_detector)

Smoke Detector
=============

Error Reporting Gem


Installation
-------------

Add the following to your `Gemfile`:
```
gem 'smoke_detector'
```
This assumes you're using Lumos Labs' gemfury account.

Then add the provider's gem to your gemfile. Smoke Detector currently supports Rollbar and Airbrake. For example,
```
gem 'airbrake'
gem 'rollbar'
```

Finally, create an initializer file `config/initializers/smoke_detector.rb`:
```
module SmokeDetector

  class Engine < Rails::Engine

    config.providers = [
      {provider: :airbrake,
        api_key: ENV['AIRBRAKE_KEY']
      },
      {provider: :rollbar,
        api_key: ENV['ROLLBAR_KEY']
      }
    ]

  end
end
```

JavaScript Client Error Tracking
--------------------------------

[Rollbar.js](https://github.com/rollbar/rollbar.js) is supported, and SmokeDetector
will automatically include the javascript snippet into the `\<head\>` of your site
if you pass in the `api_key` to the provider config:

```
config.providers = [
  {
    provider: :rollbar,
    api_key: ENV['ROLLBAR_KEY'],
    client_settings: {
      api_key: ENV['ROLLBAR_CLIENT_KEY']
    }
  }
]
```

This will give you access to using `Rollbar.error`, `Rollbar.warning`, `Rollbar.info` and
`Rollbar.debug` in your JavaScript code. Additionally, Rollbar.js automatically binds to
`window.onerror` to track any unhandled exceptions. The one caveat here is that
some browser extensions can have errors, and those errors will get picked up
by Rollbar.js unless you do some additional filtering.

The following config demonstrates how to filter JavaScript exceptions by
the exception's message, and also, by the offending exception's source host url.
You can choose to filter by `host_whitelist` or `ignored_messages` or both. It's
up to you.

```
config.providers = [
  {
    provider: :rollbar,
    api_key: ENV['ROLLBAR_KEY'],
    client_settings: {
      api_key: ENV['ROLLBAR_CLIENT_KEY'],
      ignored_messages: ["Error: Clippy.bmp not found. The end is nigh."],
      host_whitelist: ["yourdomain.com", "cdn.anotherdomain.com"]
    }
  }
]
```


TODO
----
1. Add support for capistrano deploy announcements
