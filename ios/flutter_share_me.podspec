#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_share_me'
  s.version          = '0.9.2'
  s.summary          = 'Flutter Plugin for sharing contents to social media.'
  s.description      = <<-DESC
Flutter Plugin for sharing contents to social media.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'

  s.dependency 'FBSDKShareKit', '5.11.1'
  s.dependency 'FBSDKCoreKit', '5.12.0'

  s.ios.deployment_target = '8.0'
end

