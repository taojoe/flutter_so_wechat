#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint so_wechat.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'so_wechat'
  s.version          = '0.0.1'
  s.summary          = 'A new flutter plugin project.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'WechatOpenSDK'
  s.static_framework = true
  s.libraries = ["z", "sqlite3.0", "c++"]
  s.preserve_paths = 'Lib/*.a'
  s.vendored_libraries = "**/*.a"
  #s.xcconfig = { 'SWIFT_OBJC_BRIDGING_HEADER' => 'Classes/so_wechat_bridging_header.h' }
  s.platform = :ios, '8.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.0'
end
