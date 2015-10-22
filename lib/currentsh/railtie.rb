require 'rails/railtie'

module Currentsh
  class Railtie < Rails::Railtie
    DYNO_RUN = /^run\./

    config.currentsh = ActiveSupport::OrderedOptions.new
    config.currentsh.enabled = false
    config.currentsh.heroku_detect = true

    config.after_initialize do |app|
      next unless app.config.currentsh.enabled

      if config.currentsh.heroku_detect
        # Disable logging in a heroku run session
        next if dyno = ENV['DYNO'] and DYNO_RUN.match(dyno)
      end

      Currentsh::PROCESS.track_rails!(app)
    end
  end
end

