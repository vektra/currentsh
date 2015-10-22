module Currentsh
  class LogOutput
    def initialize(io=$stdout)
      @io = io
    end

    def format(data)
      "@current: #{data.to_json}\n"
    end

    def <<(data)
      @io << format(data)
    end

    def self.with_context(msg)
      Thread.current[:currrentsh_sidekiq_context] ||= []
      Thread.current[:currrentsh_sidekiq_context] << msg
      yield
    ensure
      Thread.current[:currrentsh_sidekiq_context].pop
    end

    def call(severity, time, program_name, message)
      data = {
        time: time,
        process: ::Process.pid,
        thread: Thread.current.object_id.to_s(36),
        message: message
      }

      if ctx = context
        data.merge! ctx
      end

      format data
    end

    def context
      Thread.current[:currrentsh_sidekiq_context]
    end
  end
end
