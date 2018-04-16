lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "health_monitor/version"

Gem::Specification.new do |spec|
  spec.name          = "rt_health_monitor"
  spec.version       = HealthMonitor::VERSION
  spec.authors       = ["Martin Fuehrlinger", "0xdco", "Georg Gadinger"]
  spec.email         = ["maf@runtastic.com", "wv@0xd.co", "nilsding@nilsding.org"]

  spec.summary       = "Monitor your db and services health!"
  spec.description   = "Monitoring"
  spec.homepage      = "https://github.com/runtastic/health_monitor"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rack"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
