# frozen_string_literal: true

module BridgetownContentSecurityPolicy
  mattr_reader :policies, default: {}

  def self.configure(name, &block)
    @@policies[name.to_sym] = BridgetownContentSecurityPolicy::Policy.new(&block)
  end

  class Builder < Bridgetown::Builder
    def build
      require_relative site.in_root_dir("config", "content_security_policy.config.rb")

      unless default_policy
        Bridgetown.logger.error "\nDefault Content Security Policy not configured"
        Bridgetown.logger.info "Please configure a default CSP in content_security_policy.config.rb\n"
      end

      liquid_tag "content_security_policy" do |_attributes, tag|
        render tag.context["page"]["content_security_policy"]
      end

      helper "content_security_policy" do
        render helpers.view.page.data.content_security_policy
      end
    end

    private

    def render(policy_name = nil)
      return "" unless default_policy

      page_specific_policy_name = policy_name&.to_sym
      page_specific_policy = BridgetownContentSecurityPolicy.policies[page_specific_policy_name]

      if page_specific_policy_name && page_specific_policy.nil?
        Bridgetown.logger.warn "Unknown Content Security Policy:", page_specific_policy_name.to_s
      end

      policy = default_policy.merge(page_specific_policy)

      markup_for_policy policy
    end

    def markup_for_policy(policy)
      "<meta http-equiv=\"Content-Security-Policy\" content=\"#{policy.build}\">".html_safe
    end

    def default_policy
      BridgetownContentSecurityPolicy.policies[:default]
    end
  end
end
