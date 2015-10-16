module Currentsh
  class RailsTracker
    def initialize(output)
      @output = output
    end

    def register
      ActiveSupport::Notifications.subscribe "sql.active_record" do |*args|
        event = ActiveSupport::Notifications::Event.new *args
        sql(event)
      end

      ActiveSupport::Notifications.subscribe "process_action.action_controller" do |*args|
        event = ActiveSupport::Notifications::Event.new *args
        action(event)
      end

      ActiveSupport::Notifications.subscribe "request.action_dispatch" do |*args|
        event = ActiveSupport::Notifications::Event.new *args
        request(event)
      end
    end

    def action(event)
      data = {
        :type => "action",
        :transaction => event.transaction_id,
      }.merge(event.payload)

      @output << data
    end

    def request(event)
      request = event.payload[:request]

      data = {
        :type => "request",
        :transaction => event.transaction_id,
        :method => request.method,
        :path => request.path,
        :elapse => event.end - event.time
      }

      @output << data
    end

    def sql(event)
        binds = event.payload[:binds].map do |(attribute,value)|
          { :name => attribute.name, :type => attribute.type, :value => value }
        end


        data = {
          :type => "sql",
          :name => event.payload[:name],
          :transaction => event.transaction_id,
          :query => event.payload[:sql].strip,
          :binds => binds,
        }

      @output << data
    end
  end
end
