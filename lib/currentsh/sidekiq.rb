module Currentsh
  class Sidekiq
    def call(worker, msg, queue)
      klass = msg['wrapped'] || worker.class.to_s

      jid = msg['jid']
      context = {
        :class => klass,
        :jit => jid
      }

      if bid = msg['bid']
        context[:bid] = bid
      end

      LogOutput.with_context(context) do
        begin
          ts = start context

          yield
        rescue StandardError => ex
          case ex
          when Interrupt, SystemExit, SignalException
            raise ex
          else
            error context, ex, ts
            raise ex
          end
        else
          stop context, ts
        end
      end
    end

    def start(context)
      time = Time.now

      data = {
        time: time,
        process: ::Process.pid,
        thread: Thread.current.object_id.to_s(36),
        event: "start",
      }.merge!(context)

      $stdout.puts "@current: #{JSON.generate(data)}"

      time
    end

    def error(context, error, start)
      data = {
        time: Time.now,
        process: ::Process.pid,
        thread: Thread.current.object_id.to_s(36),
        event: "error",
        error: error.to_s,
        elapse: (Time.now - start)
      }.merge!(context)

      $stdout.puts "@current: #{JSON.generate(data)}"
    end

    def stop(context, start)
      data = {
        time: Time.now,
        process: ::Process.pid,
        thread: Thread.current.object_id.to_s(36),
        event: "stop",
        elapse: (Time.now - start)
      }.merge!(context)

      $stdout.puts "@current: #{JSON.generate(data)}"
    end

    S = ::Sidekiq

    def self.configure
      S.configure_server do |config|
        config.server_middleware do |chain|
          chain.insert_before S::Middleware::Server::Logging, self
          chain.remove S::Middleware::Server::Logging
        end
      end

      oldlogger = S::Logging.logger

      logger = Logger.new($stdout)
      logger.level = Logger::INFO
      logger.formatter = LogOutput.new

      S::Logging.logger = logger
    end
  end
end

# If using Sidekiq with Rails (likely) then the Railtie will sort this out

if defined?(Rails)
  Currentsh::PROCESS.add_initializer do
    Currentsh::Sidekiq.configure
  end
else
  Currentsh::Sidekiq.configure
end

