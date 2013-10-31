class HealthMonitor 

  attr_accessor :name, :config, :status, :info, :time

  def initialize(params = {})
    params.each do |k,v|
      self.send("#{k}=",v) if self.respond_to?("#{k}=")
    end
    @targets ||= []
  end

  def get_status(params = {})
    self.status = :up 

    check = params["check"].try(:split,',') || @targets.map(&:name)
    check = check.map{ |t| t.downcase }
    
    dont_check = params["dont_check"].try(:split,',') || []
    dont_check = dont_check.map{ |t| t.downcase }

    result = { status: status, name: name } 
    result[:time] = time if time
    result[:info] = info.slice("simple","service") if info

    (@targets || []).each do |target|

      next unless check.include?(target.name.downcase)
      next if dont_check.include?(target.name.downcase)

      res = target.get_status 

      result[target.type] ||= []
      result[target.type] << res
      
      result[:status] = :down if res[:status].to_sym == :down
    end

    self.status = result[:status]

    result
  end

  def add_target(target)
    @targets << target
  end

  def add_simple(opts, &block)
    add_target(SimpleHealthMonitor.new(opts, &block))
  end

  def add_service(opts, &block)
    add_target(ServiceHealthMonitor.new(opts, &block))
  end

end
