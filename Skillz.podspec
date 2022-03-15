Pod::Spec.new do |spec|
  spec.name         = 'Skillz'
  # TODO: update this version number to be dynamically updated based on the tag
  spec.version      = '27.2.4'

  spec.license      = { :type => 'Proprietary', :text => 'The full license is available on our website: https://www.skillz.com/legal/#dev-terms' }
  spec.homepage     = 'https://developers.skillz.com'
  spec.authors      = { 'Skillz Inc.' => 'integrations@skillz.com' } ### this will probably need to get changed
  spec.summary      = 'A multiplayer cash tournament framework for mobile.'

  spec.platform     = :ios
  # TODO: once we know what we are doing for dev console uploads, this url will be replaced by some mechanism that we can use to dynamically update it when we do dev console pushes
  spec.source       = { :http => 'https://cdn.skillz.com/devportal2/uploads/mobile_sdk_releases/ios_sdk/skillz_ios_27.2.4.tgz' }

  spec.source_files = '**/*.h'
  spec.public_header_files = "Skillz.framework/Headers/*.h"


  spec.module_name = 'Skillz'
  spec.ios.vendored_frameworks = 'Skillz.framework'
#  spec.ios.vendored_frameworks = 'Skillz.xcframework'
  spec.ios.deployment_target  = '12.0'


  # Dynamic framework dependencies here ONLY
  # spec.dependency 'Podname', 'version.number'


  spec.frameworks = 'CoreImage', 'CoreFoundation', 'PassKit', 'UIKit', 'JavaScriptCore', 'iAd'
  spec.libraries = 'sqlite3', 'z', 'xml2'


  spec.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  spec.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

end
