BridgetownContentSecurityPolicy.configure :default do |policy|
    policy.default_src :self
    policy.font_src    :self, :https, :data
    policy.img_src     :self, :https, :data
    policy.object_src  :none
    policy.script_src  :self, :https
    policy.style_src   :self, :https
end

BridgetownContentSecurityPolicy.configure :allow_https do |policy|
    policy.default_src :self, :https
end
