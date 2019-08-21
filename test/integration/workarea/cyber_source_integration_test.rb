require "test_helper"

module Workarea
  class CyberSourceIntegrationTest < Workarea::TestCase
    include CyberSourceGatewayVCRConfig

    def test_store_auth
      VCR.use_cassette "cyber_source/store_auth" do
        Payment::StoreCreditCard.new(tender).perform!

        transaction = tender.build_transaction(action: "authorize", amount: 5.to_m)
        operation = Payment::Authorize::CreditCard.new(tender, transaction)
        operation.complete!
        assert(transaction.success?)
        transaction.save!

        assert(tender.token.present?)
      end
    end

    def test_store_purchase
      VCR.use_cassette "cyber_source/store_purchase" do
        Payment::StoreCreditCard.new(tender).perform!

        transaction = tender.build_transaction(action: "purchase", amount: 5.to_m)
        operation = Payment::Purchase::CreditCard.new(tender, transaction)
        operation.complete!
        assert(transaction.success?)
        transaction.save!

        assert(tender.token.present?)
      end
    end

    def test_auth_capture
      VCR.use_cassette "cyber_source/auth_capture" do
        transaction = tender.build_transaction(action: "authorize", amount: 5.to_m)
        operation = Payment::Authorize::CreditCard.new(tender, transaction)
        operation.complete!
        assert(transaction.success?, "expected authorization to be successful")
        transaction.save!

        assert(tender.token.present?)

        capture = Payment::Capture.new(payment: payment)
        capture.allocate_amounts!(total: 5.to_m)
        assert(capture.valid?)
        capture.complete!

        capture_transaction = payment.transactions.detect(&:captures)
        assert(capture_transaction.valid?)
      end
    end

    def test_auth_void
      VCR.use_cassette "cyber_source/auth_void" do
        transaction = tender.build_transaction(action: "authorize", amount: 5.to_m)
        operation = Payment::Authorize::CreditCard.new(tender, transaction)
        operation.complete!
        assert(transaction.success?)
        transaction.save!

        assert(tender.token.present?)

        void = gateway.void(transaction.response.authorization)

        assert(void.success?)
      end
    end

    def test_purchase_void
      VCR.use_cassette "cyber_source/purchase_void" do
        transaction = tender.build_transaction(action: "purchase", amount: 5.to_m)
        operation = Payment::Purchase::CreditCard.new(tender, transaction)
        operation.complete!
        assert(transaction.success?)
        transaction.save!

        assert(tender.token.present?)

        void = gateway.void(transaction.response.authorization)

        assert(void.success?)
      end
    end

    def test_auth_capture_refund
      VCR.use_cassette "cyber_source/auth_capture_refund" do
        transaction = tender.build_transaction(action: "authorize", amount: 5.to_m)
        operation = Payment::Authorize::CreditCard.new(tender, transaction)
        operation.complete!
        assert(transaction.success?)
        transaction.save!

        assert(tender.token.present?)

        capture = Payment::Capture.new(payment: payment)
        capture.allocate_amounts!(total: 5.to_m)
        assert(capture.valid?)
        capture.complete!

        capture_transaction = payment.transactions.detect(&:captures)
        assert(capture_transaction.valid?)

        refund = Payment::Refund.new(payment: payment)
        refund.allocate_amounts!(total: 5.to_m)

        assert(refund.valid?)
        refund.complete!

        refund_transaction = payment.credit_card.transactions.refunds.first
        assert(refund_transaction.valid?)
      end
    end

    def test_purchase_refund
      VCR.use_cassette "cyber_source/purchase_refund" do
        transaction = tender.build_transaction(action: "purchase", amount: 5.to_m)
        operation = Payment::Purchase::CreditCard.new(tender, transaction)
        operation.complete!
        assert(transaction.success?)
        transaction.save!

        assert(tender.token.present?)

        refund = Payment::Refund.new(payment: payment)
        refund.allocate_amounts!(total: 5.to_m)

        assert(refund.valid?)
        refund.complete!

        refund_transaction = payment.credit_card.transactions.refunds.first
        assert(refund_transaction.valid?)
      end
    end

    private
      def email
        "bcrouse@weblinc.com"
      end

      def order
        @order ||= Order.new(email: email)
      end

      def payment_profile
        @payment_profile ||= Payment::Profile.lookup(
          PaymentReference.new(nil, order)
        )
      end

      def gateway
        Workarea.config.gateways.credit_card
      end

      def payment
        @payment ||=
          begin
            result = create_payment(
              address: {
                first_name: "Ben",
                last_name: "Crouse",
                street: "22 s. 3rd st.",
                city: "Philadelphia",
                region: "PA",
                postal_code: "19106",
                country: Country["US"]
              }
            )
            result.profile = payment_profile
            result
          end
      end

      def tender
        @tender ||=
          begin
            payment.set_address(first_name: "Ben", last_name: "Crouse")

            payment.build_credit_card(
              number: 4111111111111111,
              month: 1,
              year: Time.current.year + 1,
              cvv: 999
            )

            payment.credit_card
          end
      end
  end
end
