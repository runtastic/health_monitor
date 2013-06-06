class ServiceHealthMonitor < HealthMonitor
  def type
    :service
  end
  
  def initialize(params = {}, &block)
    params.each do |k,v|
      self.send("#{k}=",v) if self.respond_to?("#{k}=")
    end

    begin
      self.time = Benchmark.measure do
        self.info = JSON.parse(block.call)  if block
      end.real * 1000
      self.status = self.info["status"]
    rescue 
      self.status = :down
    end
  end
end
