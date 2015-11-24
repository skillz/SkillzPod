Pod::Spec.new do |s|
  s.name         = "Skillz"
  s.version      = "12.1.9"
  s.summary      = "A multiplayer cash tournament framework for mobile."

  s.description  = <<-DESC
                   Skillz is a multiplayer cash tournament for mobile that enables players to win cash for their skill!

                   * Head-to-head, timed tournaments
                   * Turn-based tournaments
                   * Objective-C and Swift support
                   * Visit www.skillz.com for more information and help with integration
                   DESC

  s.homepage     = "http://www.skillz.com"
  s.license      = { :type => "Proprietary", :file => "LICENSE" }
  s.author             = { "Skillz Inc." => "integrations@skillz.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/skillz/SkillzPod.git", :tag => "12.1.9" }
  s.module_name  = "Skillz"
  s.ios.vendored_frameworks  = 'Skillz.framework'
  s.libraries = "c++", "z", "sqlite3", "xml2"
  s.compiler_flags = '-ObjC'
end
