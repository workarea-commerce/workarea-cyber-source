ActiveMerchant::Billing::CyberSourceGateway.class_eval do
  def add_payment_method_or_subscription(xml, money, payment_method_or_reference, options)
    if payment_method_or_reference.is_a?(String)
      add_address(xml, nil, options[:billing_address], options)
      add_purchase_data(xml, money, true, options)
      add_subscription(xml, options, payment_method_or_reference)
    elsif card_brand(payment_method_or_reference) == 'check'
      add_address(xml, payment_method_or_reference, options[:billing_address], options)
      add_purchase_data(xml, money, true, options)
      add_check(xml, payment_method_or_reference)
    else
      add_address(xml, payment_method_or_reference, options[:billing_address], options)
      add_address(xml, payment_method_or_reference, options[:shipping_address], options, true)
      add_purchase_data(xml, money, true, options)
      add_creditcard(xml, payment_method_or_reference)
    end
  end

  def build_void_request(identification, options)
    order_id, request_id, request_token, action, money, currency  = identification.split(";")
    options[:order_id] = order_id

    xml = Builder::XmlMarkup.new :indent => 2
    # normal active merchant only has if capture, but purchases should be the same as captures
    # a pr was submited to active merchant, remove this if it ever gets mergex / fixed upstream
    if action == "capture" || action == "purchase"
      add_void_service(xml, request_id, request_token)
    else
      add_purchase_data(xml, money, true, options.merge(:currency => currency || default_currency))
      add_auth_reversal_service(xml, request_id, request_token)
    end
    xml.target!
  end
end
