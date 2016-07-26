Pod::Spec.new do |s|
  s.name         = "JTTranslator"
  s.version      = "1.0.1"
  s.summary      = "Remotely manage your translations on iOS"
  s.homepage     = "https://github.com/jonathantribouharet/jt-translator-ios"
  s.license      = { :type => 'MIT' }
  s.author       = { "Jonathan Tribouharet" => "jonathan.tribouharet@gmail.com" }
  s.platform     = :ios, '8.0'
  s.source       = { :git => "https://github.com/jonathantribouharet/jt-translator-ios.git", :tag => s.version.to_s }
  s.source_files  = 'JTTranslator/*'
  s.requires_arc = true
end
