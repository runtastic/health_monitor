require 'rack'
require 'json'

class HealthMonitorMiddleware

  @@monitor = HealthMonitor.new(name: nil)

  def initialize(app, name, uri = nil)
    @app = app
    @uri = uri || "health_monitor"
    @@monitor.name = name
  end

  def call(env)
    return @app.call(env) unless env["REQUEST_URI"] =~ /#{@uri}/
    request = Rack::Request.new(env)

    stime = Time.now
    data = @@monitor.get_status(request.params)
    data[:time] = (Time.now - stime)

    make_response(env, data)
  end

  def self.add(type, params, &block)
    @@monitor.send("add_#{type}", params, &block)
  end

  private def response_code(data)
    return 503 unless data[:status] == :up
    200
  end

  private def xml_response(data)
    status = (data[:status] == :up) ? 'OK' : 'FAILED'
    '<pingdom_http_custom_check>' \
    "<status>#{status}</status>" \
    "<response_time>#{data[:time].round(3)}</response_time>" \
    '</pingdom_http_custom_check>'
  end

  private def make_response(env, data)
    if env['REQUEST_URI'] =~ /pingdom/
      return [response_code(data), { 'Content-Type' => 'application/xml' }, [xml_response(data)]]
    end
    [response_code(data), { 'Content-Type' => 'application/json' }, [data.to_json]]
  end
end
