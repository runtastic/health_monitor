# frozen_string_literal: true

require "rake"

class RakeTask
  include Rake::DSL if defined? Rake::DSL

  def install_tasks
    desc "Check if Sidekiq is running"
    task "health_monitor:sidekiq:health" => :environment do
      hostname = ENV["HOSTNAME"] || `hostname -f`.strip
      ps = Sidekiq::ProcessSet.new
      up = ps.any? { |p| p["hostname"] == hostname && p["quiet"] == "false" }

      if up
        puts "UP"
        exit 0
      end

      puts "DOWN"
      exit 1
    end
  end
end

RakeTask.new.install_tasks
