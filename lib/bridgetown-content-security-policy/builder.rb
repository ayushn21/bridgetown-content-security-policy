# frozen_string_literal: true

module BridgetownContentSecurityPolicy
  mattr_reader :policies, default: {}

  def self.configure(name, &block)
    @@policies[name.to_sym] = BridgetownContentSecurityPolicy::Policy.new(&block)
  end

  class Builder < Bridgetown::Builder
    def build
      require_relative site.in_root_dir("content_security_policy.config.rb")

      unless default_policy
        # rubocop:disable Layout/LineLength
        Bridgetown.logger.error "\nDefault Content Security Policy not configured"
        Bridgetown.logger.info "Please configure a default CSP in content_security_policy.config.rb\n"
        # rubocop:enable Layout/LineLength
      end

      liquid_tag "content_security_policy", :render
    end

    private

    def render(_attributes, tag)
      return "" unless default_policy

      page_specific_policy_name = tag.context["page"]["content_security_policy"]&.to_sym
      page_specific_policy = BridgetownContentSecurityPolicy.policies[page_specific_policy_name]

      if page_specific_policy_name && page_specific_policy.nil?
        Bridgetown.logger.warn "Unknown Content Security Policy:", page_specific_policy_name.to_s
      end

      policy = default_policy.merge(page_specific_policy)

      render_policy policy
    end

    def render_policy(policy)
      "<meta http-equiv=\"Content-Security-Policy\" content=\"#{policy.build}\">"
    end

    def default_policy
      BridgetownContentSecurityPolicy.policies[:default]
    end
  end
end
