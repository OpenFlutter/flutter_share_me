#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_share_me'
  s.version          = '0.0.1'
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
  s.dependency 'FBSDKShareKit', '~> 14.0.0'
  s.dependency 'FBSDKCoreKit', '~> 14.0.0'
  s.dependency 'FBSDKLoginKit', '~> 14.0.0'
  s.ios.deployment_target = '10.0'
end

