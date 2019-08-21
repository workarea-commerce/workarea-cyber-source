# This file contains changes coming in Workarea 3.2 which are used in the payment
# integration tests

module Workarea
  if Workarea::VERSION::MAJOR == 3 && Workarea::VERSION::MINOR < 2
    decorate Payment::Refund, with: :workarea_backports do
      # Set amounts for tenders automatically (as opposed to custom amounts)
      # This will reset the current amount!
      def allocate_amounts!(total:)
        self.amounts = {}
        allocated_amount = 0.to_m

        payment.tenders.reverse.each do |tender|
          amount_for_this_tender = total - allocated_amount

          if amount_for_this_tender > tender.refundable_amount
            amount_for_this_tender = tender.refundable_amount
          end

          allocated_amount += amount_for_this_tender
          amounts[tender.id] = amount_for_this_tender
        end
      end
    end

    decorate Payment::Capture, with: :workarea_backports do
      # Set amounts for tenders automatically (as opposed to custom amounts)
      # This will reset the current amounts!
      def allocate_amounts!(total:)
        self.amounts = {}
        allocated_amount = 0.to_m

        payment.tenders.each do |tender|
          amount_for_this_tender = total - allocated_amount

          if amount_for_this_tender > tender.capturable_amount
            amount_for_this_tender = tender.capturable_amount
          end

          allocated_amount += amount_for_this_tender
          amounts[tender.id] = amount_for_this_tender
        end
      end
    end

    decorate Payment::Capture, Payment::Refund, with: :workarea_processing_backports do
      # Deal with inconsistent Mongoid serializing of Money within a Hash field
      def parse_amount(amount)
        if Money === amount || String === amount || Integer === amount || Float === amount
          amount.to_m
        else
          Money.demongoize(amount)
        end
      end
    end
  end
end
