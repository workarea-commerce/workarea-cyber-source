Workarea Cyber Source
================================================================================

Getting Started
--------------------------------------------------------------------------------

Add the gem to your application's Gemfile:

```ruby
# ...
gem 'workarea-cyber_source'
# ...
```

Update your application's bundle.

```bash
cd path/to/application
bundle
```

Add your credentials to your `config/secrets.yml`:

```yaml
cyber_source:
  login: YOUR LOGIN
  password: YOUR PASSWORD
  ignore_avs: false # disable avs - set to true unless production
  ignore_cvv: false # disable cvv - set to true unless production
  test: true # ONLY FOR STAGING!! Uses the auth.net sandbox
```

Workarea Commerce Documentation
--------------------------------------------------------------------------------

See [https://developer.workarea.com](https://developer.workarea.com) for Workarea Commerce documentation.

License
--------------------------------------------------------------------------------

Workarea Cyber Source is released under the [Business Software License](LICENSE)
