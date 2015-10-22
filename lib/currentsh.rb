require "currentsh/version"
require 'currentsh/process'
require 'currentsh/rails'

module Currentsh
  PROCESS = Process.new

  def self.track_rails!
    PROCESS.track_rails!
  end
end

require 'currentsh/railtie' if defined?(Rails)
require 'currentsh/sidekiq' if defined?(Sidekiq)
