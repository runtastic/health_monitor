Purpose
=======

* Get information about your applications health status easily

Usage
=====

Add the gem to your Gemfile

    gem 'health_monitor'

Add the middleware to your config.

### Rails

Add to you Rails configuration (config/application.rb)

    module <ApplicationName>
      class Application < Rails::Application
        config.middleware.use ::HealthMonitorMiddleware, "your_application_name"
      end
    end

### Sinatra

Add to config.ru

    use HealthMonitorMiddleware, "your_application_name"

### Padrino

Add to config/apps.rb

    Padrino.use(HealthMonitorMiddleware, "your_application_name")


## Configure your dependencies

Put into some place which is loaded on startup, like config/initializer/health_monitor_initializer.rb

    HealthMonitorMiddleware.add("simple", name: "MySQL") { User.where{id > 0}.limit(1) }
  
    HealthMonitorMiddleware.add("service", name: 'some_service_name') { RestClient.get(File.join(service-url, 'healthmonitor')) }

Simple-Monitor needs some block which returns true or false for up an down state. Service-Monitor needs an block which returns a complete status response in JSON format. This may be just the health-monitor used by a service.

## Outcome

As soon as the middleware is configured and your application is running, you can acess the health monitor status page adding 'healthmonitor' to your url. It does not depend on the given path.

    http://your_application_url_with_some_path/healthmonitor

This would lead to the following output f.e.:

    {
      status: "down",
      name: "my app",
      simple: [
      {
        status: "up",
        name: "MySQL",
        time: 0.2758502960205078
      },
      {
        status: "up",
        name: "Memcached",
        time: 1.4078617095947266
      },
      {
        status: "up",
        name: "Resque",
        time: 3.2737255096435547
      }
      ],
      service: [
      {
        status: "down",
        name: "routes",
        time: 1295.3431606292725
      },
      {
        status: "up",
        name: "appendix",
        info: {
          simple: [
            {
              status: "up",
              name: "MongoDB",
              time: 6.000041961669922
            },
            {
              status: "up",
              name: "MySQL",
              time: 0
            }
          ]
        },
        time: 23.989439010620117
      },
    ...
    }
