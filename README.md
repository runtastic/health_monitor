# rt_health_monitor

[![Gem Version](https://badge.fury.io/rb/rt_health_monitor.svg)](https://badge.fury.io/rb/rt_health_monitor)

Get information about your applications health status easily.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rt_health_monitor', require: 'health_monitor'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rt_health_monitor

## Usage

Add the middleware to your config.

### Rails

Add to you Rails configuration (config/application.rb)

```ruby
module <ApplicationName>
  class Application < Rails::Application
    config.middleware.use ::HealthMonitorMiddleware, "your_application_name"
  end
end
```

### Sinatra

Add to config.ru

```ruby
use HealthMonitorMiddleware, "your_application_name"
```

### Padrino

Add to config/apps.rb

```ruby
Padrino.use(HealthMonitorMiddleware, "your_application_name")
```

## Configure your dependencies

Put into some place which is loaded on startup, like
`config/initializer/health_monitor_initializer.rb`

```ruby
HealthMonitorMiddleware.add("simple", name: "MySQL") { User.where{id > 0}.limit(1) }

HealthMonitorMiddleware.add("service", name: 'some_service_name') { RestClient.get(File.join(service-url, 'healthmonitor')) }
```

Simple-Monitor needs some block which returns true or false for up an down
state. Service-Monitor needs an block which returns a complete status response
in JSON format. This may be just the health-monitor used by a service.

## Outcome

As soon as the middleware is configured and your application is running, you can
acess the health monitor status page adding 'health_monitor' to your url. It does
not depend on the given path.

    http://your_application_url_with_some_path/health_monitor

This would lead to the following output:

```json
{
  "status": "down",
  "name": "my app",
  "simple": [
    {
      "status": "up",
      "name": "MySQL",
      "time": 0.2758502960205078
    },
    {
      "status": "up",
      "name": "Memcached",
      "time": 1.4078617095947266
    },
    {
      "status": "up",
      "name": "Resque",
      "time": 3.2737255096435547
    }
  ],
  "service": [
    {
      "status": "down",
      "name": "routes",
      "time": 1295.3431606292725
    },
    {
      "status": "up",
      "name": "appendix",
      "info": {
        "simple": [
          {
            "status": "up",
            "name": "MongoDB",
            "time": 6.000041961669922
          },
          {
            "status": "up",
            "name": "MySQL",
            "time": 0
          }
        ]
      },
      "time": 23.989439010620117
    },
    ...
  ]
}
```


## Sidekiq Health Check Task

A task for performing a Sidekiq health check is also included. To use that, just
add the following line to your `Rakefile`

```ruby
require "health_monitor/rake_task"
```

You must have a `environment` task in your `Rakefile` which loads the
environment.  Rails already provides such a task.

A simple environment task looks like this:

```ruby
task :environment do
  require_relative "./config/environment" if File.exists?("./config/environment")
end
```
