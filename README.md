# RtHealthMonitor

[![Gem Version](https://badge.fury.io/rb/rt_health_monitor.svg)][rubygems]

Get information about your applications health status easily.

As soon as the gem is configured and your application is running, you can
access a health monitor status, e.g. http://example.com/health_monitor

This would produce the following output:

```json
{
  "status": "down",
  "name": "my service",
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
    }
  ],
  "service": [
    {
      "status": "up",
      "name": "another service",
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
    }
  ]
}
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'rt_health_monitor', require: 'health_monitor'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rt_health_monitor

## Configuration

### Rails

Add the middleware to your Rails configuration

```ruby
module <ApplicationName>
  class Application < Rails::Application
    config.middleware.use ::HealthMonitorMiddleware, "your_application_name"
  end
end
```

### Sinatra

Add the middleware to your `config.ru`

```ruby
use HealthMonitorMiddleware, "your_application_name"
```

### Padrino

Add the middleware to `config/apps.rb`

```ruby
Padrino.use(HealthMonitorMiddleware, "your_application_name")
```

## Usage

Put the following configurations some place where they are loaded on startup,
like `config/initializer/health_monitor_initializer.rb`

### Simple monitors
These can be used to monitor a database connection or anything that can be in two
states.

Example:
```ruby
HealthMonitorMiddleware.add("simple", name: "MySQL") do
  ActiveRecord::Base.connected?
end
```

### Service monitors

These can be used to monitor another service that is also using this gem. The block
needs to return the result of the `/health_monitor` endpoint of the other service:

```ruby
HealthMonitorMiddleware.add("service", name: 'some_service_name') do
  RestClient.get("https://some-service.example.com/health_monitor")
end
```

### Sidekiq Health Check Task

A task for performing a Sidekiq health check is also included. To use that, just
add the following line to your `Rakefile`

```ruby
require "health_monitor/rake_task"
```

You must have an `environment` task in your `Rakefile` which loads the
environment. Rails already provides such a task.

A simple environment task looks like this:

```ruby
task :environment do
  require_relative "./config/environment" if File.exists?("./config/environment")
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can
also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push git
commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/runtastic/rt_health_monitor.
This project is intended to be a safe, welcoming space for collaboration, and
contributors are expected to adhere to the [code of conduct][cc].

## License
The gem is available as open source under [the terms of the MIT License][mit].

[travis]: https://travis-ci.org/runtastic/rt_health_monitor
[rubygems]: https://rubygems.org/gems/rt_health_monitor
[mit]: https://choosealicense.com/licenses/mit/
[cc]: ../CODE_OF_CONDUCT.md
