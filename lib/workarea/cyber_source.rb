require "workarea"
require "workarea/storefront"
require "workarea/admin"
require "active_merchant/billing/bogus_cyber_source_gateway"
require "active_merchant/billing/cyber_source_fix"

require "workarea/cyber_source/engine"
require "workarea/cyber_source/version"

module Workarea
  module CyberSource
    def self.auto_configure_gateway
      if Rails.application.secrets.cyber_source.present?
        if ENV["HTTP_PROXY"].present?
          uri = URI.parse(ENV["HTTP_PROXY"])
          ActiveMerchant::Billing::CyberSourceGateway.proxy_address = uri.host
          ActiveMerchant::Billing::CyberSourceGateway.proxy_port = uri.port
        end

        self.gateway = ActiveMerchant::Billing::CyberSourceGateway.new(
          Rails.application.secrets.cyber_source.deep_symbolize_keys
        )
      else
        self.gateway = ActiveMerchant::Billing::BogusCyberSourceGateway.new
      end
    end

    def self.gateway
      Workarea.config.gateways.credit_card
    end

    def self.gateway=(gateway)
      Workarea.config.gateways.credit_card = gateway
    end
  end
end
