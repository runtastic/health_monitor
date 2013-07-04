class HealthMonitorMiddleware

  @@monitor = HealthMonitor.new(name: nil)

  def initialize(app, name)
    @app = app
    @@monitor.name = name
  end
  
  def call(env)
    if env["REQUEST_URI"] =~ /healthmonitor/
      request = Rack::Request.new(env)

      data = @@monitor.get_status(request.params)

      [200, { 'Content-Type' => 'application/json' }, [ data.to_json ]]
    else 
      @app.call(env)
    end
  end

  def self.add(type, params, &block) 
    @@monitor.send("add_#{type}", params, &block)  
  end

end

