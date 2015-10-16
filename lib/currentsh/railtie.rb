require 'rails/railtie'

module Currentsh
  class Railtie < Rails::Railtie
    config.currentsh = ActiveSupport::OrderedOptions.new
    config.currentsh.enabled = false

    config.after_initialize do |app|
      Currentsh::PROCESS.track_rails!(app) if app.config.currentsh.enabled
    end
  end
end

