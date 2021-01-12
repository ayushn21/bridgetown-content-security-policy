require "helper"

class TestContentSecurityPolicy < BridgetownContentSecurityPolicy::Test
    
  should "generate CSP for index as defined in the default policy" do
    expected_csp = "default-src 'self'; font-src 'self' https: data:; img-src 'self' https: data:; object-src 'none'; script-src 'self' https:; style-src 'self' https:"
    page = Nokogiri::HTML File.read(dest_dir("index.html"))
    
    generated_csp = extract_content_security_policy page
    assert_equal expected_csp, generated_csp
  end
  
  should "generate CSP for about as overriden in allow_https policy" do
    expected_csp = "default-src 'self' https:; font-src 'self' https: data:; img-src 'self' https: data:; object-src 'none'; script-src 'self' https:; style-src 'self' https:"
    page = Nokogiri::HTML File.read(dest_dir("about.html"))
    
    generated_csp = extract_content_security_policy page
    assert_equal expected_csp, generated_csp
  end
  
  private
    def extract_content_security_policy(html_page)
      html_page.at_css("meta[http-equiv=Content-Security-Policy]").attributes["content"].value
    end
end