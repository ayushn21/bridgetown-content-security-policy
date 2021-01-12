# frozen_string_literal: true

module BridgetownContentSecurityPolicy
  class Policy
    MAPPINGS = {
      self: "'self'",
      unsafe_eval: "'unsafe-eval'",
      unsafe_inline: "'unsafe-inline'",
      none: "'none'",
      http: "http:",
      https: "https:",
      data: "data:",
      mediastream: "mediastream:",
      blob: "blob:",
      filesystem: "filesystem:",
      report_sample: "'report-sample'",
      strict_dynamic: "'strict-dynamic'",
      ws: "ws:",
      wss: "wss:",
    }.freeze

    DIRECTIVES = {
      base_uri: "base-uri",
      child_src: "child-src",
      connect_src: "connect-src",
      default_src: "default-src",
      font_src: "font-src",
      form_action: "form-action",
      frame_ancestors: "frame-ancestors",
      frame_src: "frame-src",
      img_src: "img-src",
      manifest_src: "manifest-src",
      media_src: "media-src",
      object_src: "object-src",
      prefetch_src: "prefetch-src",
      script_src: "script-src",
      script_src_attr: "script-src-attr",
      script_src_elem: "script-src-elem",
      style_src: "style-src",
      style_src_attr: "style-src-attr",
      style_src_elem: "style-src-elem",
      worker_src: "worker-src",
    }.freeze

    private_constant :MAPPINGS, :DIRECTIVES

    attr_reader :directives

    def initialize(directives = nil)
      if directives
        @directives = directives
      else
        @directives = {}
        yield self if block_given?
      end
    end

    DIRECTIVES.each do |name, directive|
      define_method(name) do |*sources|
        if sources.first
          @directives[directive] = apply_mappings(sources)
        else
          @directives.delete(directive)
        end
      end
    end

    def block_all_mixed_content(enabled = true)
      if enabled
        @directives["block-all-mixed-content"] = true
      else
        @directives.delete("block-all-mixed-content")
      end
    end

    def plugin_types(*types)
      if types.first
        @directives["plugin-types"] = types
      else
        @directives.delete("plugin-types")
      end
    end

    def report_uri(uri)
      @directives["report-uri"] = [uri]
    end

    def require_sri_for(*types)
      if types.first
        @directives["require-sri-for"] = types
      else
        @directives.delete("require-sri-for")
      end
    end

    def sandbox(*values)
      if values.empty?
        @directives["sandbox"] = true
      elsif values.first
        @directives["sandbox"] = values
      else
        @directives.delete("sandbox")
      end
    end

    def upgrade_insecure_requests(enabled = true)
      if enabled
        @directives["upgrade-insecure-requests"] = true
      else
        @directives.delete("upgrade-insecure-requests")
      end
    end

    def build
      build_directives.compact.join("; ")
    end

    def merge(policy)
      if policy
        self.class.new(@directives.merge(policy.directives))
      else
        self
      end
    end

    private

    def apply_mappings(sources)
      sources.map do |source|
        case source
        when Symbol
          apply_mapping(source)
        when String
          source
        else
          raise ArgumentError, "Invalid content security policy source: #{source.inspect}"
        end
      end
    end

    def apply_mapping(source)
      MAPPINGS.fetch(source) do
        raise ArgumentError, "Unknown content security policy source mapping: #{source.inspect}"
      end
    end

    def build_directives
      @directives.map do |directive, sources|
        if sources.is_a?(Array)
          "#{directive} #{build_directive(sources).join(" ")}"
        elsif sources
          directive
        end
      end
    end

    def build_directive(sources)
      sources.map { |source| resolve_source(source) }
    end

    def resolve_source(source)
      case source
      when String
        source
      when Symbol
        source.to_s
      else
        raise "Unexpected content security policy source: #{source.inspect}"
      end
    end
  end
end
