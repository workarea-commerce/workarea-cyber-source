Workarea Cyber Source 1.0.3 (2018-08-21)
--------------------------------------------------------------------------------

*   Open Source!



Workarea Cyber Source 1.0.2 (2018-03-02)
--------------------------------------------------------------------------------

*   Ensure address and email is passed to gateway calls

    Update options in Authorize::CreditCard / Purcahse::CreditCard initializers so
    address information is accessible StoreCreditCard
    Override #add_payment_method_or_subscription to add the address when
    using a token.

    CYBERSRC-4
    Eric Pigeon


Workarea Cyber Source 1.0.1 (2018-02-01)
--------------------------------------------------------------------------------

*   Fix tokenizing credit cards

    Cybersource can't use a token from an authorization for future
    auths/purchases.  Update Authorize::CreditCard and
    Purchase::CreditCard to call StoreCreditCard first.

    CYBERSRC-3
    Eric Pigeon

*   Add proxy from environment
    Eric Pigeon


Workarea Cyber Source 1.0.0 (2017-12-20)
--------------------------------------------------------------------------------
