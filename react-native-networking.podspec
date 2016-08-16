Pod::Spec.new do |s|
  s.name         = "react-native-networking"
  s.version      = "0.1.1"
  s.license      = "MIT"
  s.homepage     = "https://github.com/eduedix/react-native-networking"
  s.authors      = { 'eduedix' => 'eduedix@gmail.com' }
  s.summary      = "A React Native module for native networking inside react-native"
  s.source       = { :git => "https://github.com/eduedix/react-native-networking" }
  s.source_files  = "RNNetworkingManager/*.{h,m}"

  s.platform     = :ios, "8.2"
  s.dependency 'React'
  s.dependency 'AFNetworking', '~> 2.5'
end
