require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name         = 'freestar-plugin-react-native'
  s.version      = package['version']
  s.summary      = package['description']
  s.license      = package['license']

  s.authors      = package['author']
  s.homepage     = package['homepage']
  s.platforms    = { :ios => "10.0" }

  s.source       = { :git => "https://gitlab.com/freestarcapital/freestar-plugin-react-native.git", :tag => "v#{s.version}" }
  s.source_files  = "ios/**/*.{h,m}"

  s.dependency 'FreestarAds', '~> 5.25.0'
  s.dependency 'FSLPromisesObjC', '2.2.1'
  s.dependency 'React'
end
