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

    begin
      self.time = Benchmark.measure do
        self.status = !!block.call if block
      end.real * 1000
    rescue 
      self.status = false
    end

    self.status = (self.status ? :up : :down)
  end
end

