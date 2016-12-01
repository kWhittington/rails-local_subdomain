# frozen_string_literal: true
require 'rails/local_subdomain/version'
require 'rails/local_subdomain/rack/handler'

module Rails
  # Redirects to a specified domain (or `'lvh.me'` if not provided) when Rails
  # is running in an LocalSubdomain.enabled_environments environment.
  module LocalSubdomain
    extend ActiveSupport::Concern

    included do
      before_action :redirect_to_lvh_me
    end

    # Should be monkey-patched to configure which Rails environments
    # will have lvh.me subdomain support.
    def self.enabled_environments
      %w(development test)
    end

    def self.enabled_in?(env)
      enabled_environments.include?(env)
    end

    def lvh_me_domain
      'lvh.me'
    end

    def lvh_me_path
      request.env['ORIGINAL_FULLPATH']
    end

    def lvh_me_port
      request.env['SERVER_PORT']
    end

    def lvh_me_protocol
      request.env['rack.url_scheme']
    end

    def lvh_me_url
      "#{lvh_me_protocol}://#{lvh_me_domain}"\
      "#{lvh_me_port == '80' ? '' : ':' + lvh_me_port}#{lvh_me_path}"
    end

    def redirect_to_lvh_me
      return unless LocalSubdomain.enabled_in?(Rails.env)
      return if served_by_lvh_me?

      redirect_to(lvh_me_url)
    end

    def served_by_lvh_me?
      !request.env['SERVER_NAME'][/#{lvh_me_domain}$/].nil?
    end
  end
end
