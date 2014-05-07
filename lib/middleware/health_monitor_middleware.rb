class HealthMonitorMiddleware

  @@monitor = HealthMonitor.new(name: nil)

  def initialize(app, name, uri = nil)
    @app = app
    @uri = uri || "health_monitor"
    @@monitor.name = name
  end
  
  def call(env)
    if env["REQUEST_URI"] =~ /#{@uri}/

      request = Rack::Request.new(env)
      
      stime = Time.now
      data = @@monitor.get_status(request.params)
      data[:time] = (Time.now - stime)

      if env["REQUEST_URI"] =~ /pingdom/
        status = (data[:status] == :up) ? "OK" : "FAILED"
        xml_response = "<pingdom_http_custom_check><status>#{status}</status><response_time>#{data[:time]}</response_time></pingdom_http_custom_check>"
        [200, { 'Content-Type' => 'application/xml' },  [ xml_response ]]
      else
        [200, { 'Content-Type' => 'application/json' }, [ data.to_json ]]
      end
    else 
      @app.call(env)
    end
  end

  def self.add(type, params, &block) 
    @@monitor.send("add_#{type}", params, &block)  
  end

end

