Pod::Spec.new do |spec|
  spec.name         = 'Skillz'
  spec.version      = '28.0.16'

  spec.license      = { :type => 'Proprietary', :text => 'The full license is available on our website: https://www.skillz.com/legal/#dev-terms' }
  spec.homepage     = 'https://developers.skillz.com'
  spec.authors      = { 'Skillz Inc.' => 'integrations@skillz.com' }
  spec.summary      = 'A multiplayer cash tournament framework for mobile.'

  spec.platform     = :ios
  spec.source       = { :git => 'https://github.com/skillz/SkillzPod.git', :tag => spec.version.to_s }

  spec.source_files = '**/*.h'
  spec.public_header_files = "Skillz.framework/Headers/*.h"

  spec.module_name = 'Skillz'
  spec.ios.vendored_frameworks = 'Skillz.framework'
  spec.ios.deployment_target  = '12.0'

  spec.frameworks = 'CoreImage', 'CoreFoundation', 'PassKit', 'UIKit', 'JavaScriptCore', 'iAd'
  spec.libraries = 'sqlite3', 'z', 'xml2'

  spec.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  spec.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

end
