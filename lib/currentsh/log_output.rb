module Currentsh
  class LogOutput
    def initialize(io=$stdout)
      @io = io
    end

    def <<(data)
      @io.puts "@current: #{data.to_json}"
    end
  end
end
