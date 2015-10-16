require 'currentsh/log_output'

module Currentsh
  class Process
    def initialize
      @output = LogOutput.new
      @trackers = []
    end

    def track_rails!(app)
      @output << { :type => "boot", :application => app.class.name }
      rails = RailsTracker.new(@output)
      rails.register

      @trackers << rails
    end
  end
end
