# Bridgetown Content Security Policy

[![Tests](https://github.com/ayushn21/bridgetown-content-security-policy/actions/workflows/tests.yml/badge.svg?branch=main)](https://github.com/ayushn21/bridgetown-content-security-policy/actions/workflows/tests.yml)
[![Gem Version](https://badge.fury.io/rb/bridgetown-content-security-policy.svg)](https://badge.fury.io/rb/bridgetown-content-security-policy)

A Bridgetown plugin to include a [Content Security Policy](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy) as a meta tag on all your pages.

## Installation

Run this command to install this plugin:

```shell
$ bundle exec bridgetown apply https://github.com/ayushn21/bridgetown-content-security-policy
```

## Usage

The plugin allows you to define one or more Content Security Policies using a convenient Ruby DSL.

The installation should create a `content_security_policy.config.rb` file in your project's `config` directory. More info about the DSL is contained in the file.

You can define a specific CSP for pages by setting `content_security_policy:` in your frontmatter; and then defining the relevent CSP in `content_security_policy.config.rb`.

All page specific CSPs will inherit from the `default` CSP.

### Including the CSP on your web pages

You'll need to add a `content_security_policy` tag to your **layout file(s)** to include the CSP meta tag in all your pages. This plugin supports *Liquid*, *ERB* and other Tilt based templating languages like *HAML* or *Slim*.

- **Liquid templates**: `{% content_security_policy %}`
- **ERB**: `<%= content_security_policy %>`

Add the appropriate CSP tag in the `head` tag of **_your layout file_** to include the CSP on all your pages.


## Testing

* Run `bundle exec rake test` to run the test suite
* Or run `script/cibuild` to validate with Rubocop and run tests together.

## Contributing

1. Fork it (https://github.com/ayushn21/bridgetown-content-security-policy/fork)
2. Clone the fork using `git clone` to your local development machine.
3. Create your feature branch (`git checkout -b my-new-feature`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request

## License

Bridgetown Content Security Policy is released under the [MIT License](https://opensource.org/licenses/MIT).

Copyright © 2021 [Ayush Newatia](https://twitter.com/ayushn21)