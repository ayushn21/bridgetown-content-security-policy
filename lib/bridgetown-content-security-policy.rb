# frozen_string_literal: true

require "bridgetown"
require "bridgetown-content-security-policy/policy"
require "bridgetown-content-security-policy/builder"

Bridgetown.initializer :"bridgetown-content-security-policy" do |config|
  config.builder BridgetownContentSecurityPolicy::Builder
end
