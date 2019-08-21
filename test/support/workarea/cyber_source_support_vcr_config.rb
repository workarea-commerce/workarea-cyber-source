module Workarea
  module CyberSourceGatewayVCRConfig
    def self.included(test)
      test.setup :setup_gateway
      test.teardown :reset_gateway
    end

    def setup_gateway
      @_old_gateway = Workarea.config.gateways.credit_card
      Workarea.config.gateways.credit_card = ActiveMerchant::Billing::CyberSourceGateway.new(
        login:      "a",
        password:   "b",
        ignore_avs: true,
        ignore_cvv: true,
        test:       true
      )
    end

    def reset_gateway
      Workarea.config.gateways.credit_card = @_old_gateway
    end
  end
end
