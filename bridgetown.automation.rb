say_status :content_security_policy, "Installing the bridgetown-content-security-policy plugin..."

add_bridgetown_plugin "bridgetown-content-security-policy"

copy_file "./templates/content_security_policy.config.rb", "content_security_policy.config.rb"

say_status :content_security_policy, "All done! Please add {% content_security_policy %} to the head tag in your layouts."
say_status :content_security_policy, "Please see the new content_security_policy.rb file for details"
say_status :content_security_policy, "More info available at: https://github.com/ayushn21/bridgetown-content-security-policy"