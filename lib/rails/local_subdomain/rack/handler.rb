# frozen_string_literal: true
require 'rails/local_subdomain'

module Rack
  # Override the Rack::Handler to bind to 0.0.0.0 which is required to support
  # http://lvh.me redirects.
  module Handler
    class << self
      alias orig_default default
    end

    # rubocop: disable Metrics/MethodLength
    def self.default(_options = {})
      orig_default.instance_eval do
        class << self
          alias orig_run run
        end

        def self.run(app, options = {})
          env = (options[:environment] || Rails.env)

          if options[:Host] == 'localhost' &&
             Rails::LocalSubdomain.enabled_in?(env)
            message(options[:Port])
            options[:Host] = '0.0.0.0'
          end
          orig_run(app, options)
        end

        def self.message(port)
          Logger.new(STDOUT).info(
            "Binding 'localhost' to '0.0.0.0' for "\
            "http://lvh.me:#{port}/ support")
        end
      end
      orig_default
    end
    # rubocop: enable Metrics/MethodLength
  end
end
