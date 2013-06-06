class HealthMonitor 

  attr_accessor :name, :config, :status, :info, :time

  def initialize(params = {})
    params.each do |k,v|
      self.send("#{k}=",v) if self.respond_to?("#{k}=")
    end
    self.status = :up 
  end

  def get_status
    result = { status: status, name: name } 
    result[:time] = time if time
    result[:info] = info.slice("simple","service") if info

    (@targets || []).each do |target|

      res = target.get_status

      result[target.type] ||= []
      result[target.type] << res

      result[:status] = :down if res[:status] == :down
    end
    self.status = result[:status]
    result
  end


  def add_target(target)
    @targets ||= []
    @targets << target
  end

  def add_simple(opts, &block)
    add_target(SimpleHealthMonitor.new(opts, &block))
  end

  def add_service(opts, &block)
    add_target(ServiceHealthMonitor.new(opts, &block))
  end


end
