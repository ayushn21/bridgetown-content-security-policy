require "helper"
require "byebug"

class TestContentSecurityPolicy < BridgetownContentSecurityPolicy::Test

  DEFAULT_CSP = "default-src 'self'; font-src 'self' https: data:; img-src 'self' https: data:; object-src 'none'; script-src 'self' https:; style-src 'self' https:"
  ALLOW_HTTPS_CSP = "default-src 'self' https:; font-src 'self' https: data:; img-src 'self' https: data:; object-src 'none'; script-src 'self' https:; style-src 'self' https:"

  context "building the site" do
    setup { build_site }

    should "generate CSP for index as defined in the default policy" do
      @page = Nokogiri::HTML File.read(dest_dir("index.html"))

      assert_equal DEFAULT_CSP, generated_csp
    end

    should "generate CSP for about as overriden in allow_https policy" do
      @page = Nokogiri::HTML File.read(dest_dir("about.html"))

      assert_equal ALLOW_HTTPS_CSP, generated_csp
    end

    should "generate default CSP in an ERB layout" do
      @page = Nokogiri::HTML File.read(dest_dir("products", "telecaster.html"))

      assert_equal DEFAULT_CSP, generated_csp
    end

    should "generate overriden CSP in an ERB layout" do
      @page = Nokogiri::HTML File.read(dest_dir("products", "stratocaster.html"))

      assert_equal ALLOW_HTTPS_CSP, generated_csp
    end
  end

  private
    def generated_csp
      extract_content_security_policy @page
    end

    def extract_content_security_policy(html_page)
      html_page.at_css("meta[http-equiv=Content-Security-Policy]").attributes["content"].value
    end
end