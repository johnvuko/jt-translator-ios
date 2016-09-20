Pod::Spec.new do |s|
  s.name         = "JTTranslator"
  s.version      = "1.1.0"
  s.summary      = "Remotely manage your translations on iOS"
  s.homepage     = "https://github.com/jonathantribouharet/jt-translator-ios"
  s.license      = { :type => 'MIT' }
  s.author       = { "Jonathan Tribouharet" => "jonathan.tribouharet@gmail.com" }
  s.ios.deployment_target = '8.0'
  s.source       = { :git => "https://github.com/jonathantribouharet/jt-translator-ios.git", :tag => s.version.to_s }
  s.source_files  = 'Source/*.swift'
  s.requires_arc = true
end
