class ServiceHealthMonitor < HealthMonitor
  def type
    :service
  end
  
  def initialize(params = {}, &block)
    params.each do |k,v|
      self.send("#{k}=",v) if self.respond_to?("#{k}=")
    end
    
    @block = block
  end

  def get_status
    result[:info] = nil

    begin
      self.time = Benchmark.measure do
        self.info = JSON.parse(@block.call)  if @block
      end.real * 1000
      self.status = self.info["status"]
    rescue 
      self.status = :down
    end
    
    result = { status: status, name: name }
    result[:info] = info.slice("simple","service") if info
    result[:time] = time if time

    result
  end
end
