module ActiveMerchant
  module Billing
    class BogusCyberSourceGateway < BogusGateway
      def store(paysource, options = {})
        authorization = ";5118839074516426404010;Ahj/7wSTFX4pmYA85bCqKhDdq4ZOWjNklxakXpGAKXFqRekZpABykhk0kyro9JiuKBOTFX4pmYA85bCqAAAA5wQ4;store;;;5118839074516426404010"
        case normalize(paysource)
        when /1$/
          Response.new(true, SUCCESS_MESSAGE, { billingid: "1" }, { test: true, authorization: authorization })
        when /2$/
          Response.new(false, FAILURE_MESSAGE, { billingid: nil, error: FAILURE_MESSAGE }, { test: true, error_code: STANDARD_ERROR_CODE[:processing_error] })
        else
          raise Error, error_message(paysource)
        end
      end

      def authorize(money, credit_card_or_subscription, options = {})
        case normalize(credit_card_or_subscription)
        when /1$/, "5118839074516426404010"
          succuessful_auth_response
        when /2$/
          Response.new(false, FAILURE_MESSAGE, { authorized_amount: money, error: FAILURE_MESSAGE }, { test: true, error_code: STANDARD_ERROR_CODE[:processing_error] })
        else
          raise Error, error_message(credit_card_or_subscription)
        end
      end

      def purchase(money, credit_card_or_subscription, options = {})
        case normalize(credit_card_or_subscription)
        when /1$/, "5118839074516426404010"
          succuessful_purchase_response
        when /2$/
          Response.new(false, FAILURE_MESSAGE, { authorized_amount: money, error: FAILURE_MESSAGE }, { test: true, error_code: STANDARD_ERROR_CODE[:processing_error] })
        else
          raise Error, error_message(credit_card_or_subscription)
        end
      end

      private

        def normalize(paysource)
          if paysource.respond_to?(:account_number) && (paysource.try(:number).blank? || paysource.number.blank?)
            paysource.account_number
          elsif paysource.respond_to?(:number)
            paysource.number.split(";")[6] || paysource.number
          else
            paysource.to_s.split(";")[6] || paysource.to_s
          end
        end

        def succuessful_auth_response
          authorization = "5a216efd87c68b548a1856df;5118839077736067504008;Ahj/7wSTFX4pnG3edheIKhDdq4ZOWbVqlwethj1gKXB62GPXpAn6OUkMmkmVdHpMVxQJyYq/FM427zsLxAAA6xxJ;authorize;500;;"
          params = {
            "merchantReferenceCode"       => "5a1d848387c68b268bf205f9",
            "requestID"                   => "5118839077736067504008",
            "decision"                    => "ACCEPT",
            "reasonCode"                  => "100",
            "message"                     => "Successful transaction",
            "requestToken"                => "Ahj/7wSTFX4pnG3edheIKhDdq4ZOWbVqlwethj1gKXB62GPXpAn6OUkMmkmVdHpMVxQJyYq/FM427zsLxAAA6xxJ",
            "currency"                    => "USD",
            "amount"                      => "5.00",
            "authorizationCode"           => "831000",
            "avsCode"                     => "Y",
            "avsCodeRaw"                  => "Y",
            "authorizedDateTime"          => "2017-11-28T15:45:07Z",
            "processorResponse"           => "000",
            "paymentNetworkTransactionID" => "558196000003814",
            "cardCategory"                => "A",
            "ownerMerchantID"             => "weblinc"
          }
          Response.new(true, SUCCESS_MESSAGE, params, test: true, authorization: authorization)
        end

        def succuessful_purchase_response
          authorization = "5a609ec187c68b520db767eb;5161970476206134104008;Ahj//wSTF9S7HtFYm4/IESDdm1ZtGbZvKhyKjhnKtJcl3RY7YClyXdFjt6QJ+j6jDJpJl6MVzT24YE5MX1Lse0Vibj8g0UyQ;purchase;500;;"
          params = {
            "merchantReferenceCode" => "5a5f54b787c68be6e7c6a553",
            "requestID"             => "5161970476206134104008",
            "decision"              => "ACCEPT",
            "reasonCode"            => "100",
            "message"               => "Successful transaction",
            "requestToken"          => "Ahj//wSTF9S7HtFYm4/IESDdm1ZtGbZvKhyKjhnKtJcl3RY7YClyXdFjt6QJ+j6jDJpJl6MVzT24YE5MX1Lse0Vibj8g0UyQ",
            "currency"              => "USD",
            "amount"                => "5.00",
            "authorizationCode"     => "888888",
            "avsCode"               => "X",
            "avsCodeRaw"            => "I1",
            "authorizedDateTime"    => "2018-01-17T13:50:47Z",
            "processorResponse"     => "100",
            "reconciliationID"      => "73534367JCHT83JZ",
            "ownerMerchantID"       => "a",
            "requestDateTime"       => "2018-01-17T13:50:47Z"
          }
          Response.new(true, SUCCESS_MESSAGE, params, test: true, authorization: authorization)
        end
    end
  end
end
