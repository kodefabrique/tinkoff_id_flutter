#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint tinkoff_id_flutter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'tinkoff_id_flutter'
  s.version          = '0.0.1'
  s.summary          = 'Tinkoff ID Native Android And iOS Flutter Realization'
  s.description      = <<-DESC
Tinkoff ID Native Android And iOS Flutter Realization
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'T-ID'
  s.static_framework = true
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
