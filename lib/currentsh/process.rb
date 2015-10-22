require 'currentsh/log_output'

module Currentsh
  class Process
    def initialize
      @output = LogOutput.new
      @trackers = []
      @initializers = []
    end

    def add_initializer(&b)
      @initializers << b
    end

    def track_rails!(app)
      @initializers.each { |i| i.call }

      @output << { :type => "boot", :application => app.class.name }
      rails = RailsTracker.new(@output)
      rails.register

      @trackers << rails
    end
  end
end
