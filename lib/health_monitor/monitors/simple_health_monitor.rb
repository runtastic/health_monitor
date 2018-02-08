class SimpleHealthMonitor < HealthMonitor
  def type
    :simple
  end

  def info
  end

  def initialize(params = {}, &block)
    params.each do |k,v|
      self.send("#{k}=",v) if self.respond_to?("#{k}=")
    end

    @block = block
  end

  def get_status
    begin
      self.time = Benchmark.measure do
        self.status = !!@block.call if @block
      end.real * 1000
    rescue
      self.status = false
    end

    self.status = (self.status ? :up : :down)

    result = { status: status, name: name }
    result[:time] = time if time

    result
  end
end
