Pod::Spec.new do |s|
  s.name             = 'CentralX'
  s.version          = '0.1.0'
  s.summary          = 'Frameworks for iOS'
  s.homepage         = 'https://github.com/central-x/central-framework-ios'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Alan Yeh' => 'alan@yeh.cn' }
  s.source           = { :git => 'https://github.com/central-x/central-framework-ios.git', :tag => s.version.to_s }

  s.requires_arc = true
  s.platform = :ios
  s.ios.deployment_target = '11.0'
  s.ios.pod_target_xcconfig = { 'PRODUCT_BUNDLE_IDENTIFIER' => 'org.central-x' }

  s.source_files = 'CentralX/CentralX.h'
  s.public_header_files = 'CentralX/CentralX.h'

  s.subspec 'CentralBridge' do |spec|
    spec.source_files = 'CentralX/CentralBridge/Classes/**/*'
    spec.public_header_files = 'CentralX/CentralBridge/Classes/*.h'

    spec.frameworks = 'WebKit', 'UIKit', 'SystemConfiguration', 'MessageUI', 'CoreBluetooth', 'Photos', 'EventKit', 'Contacts', 'AVFoundation', 'CoreMedia', 'CoreGraphics', 'CoreLocation', 'AudioToolbox', 'CoreServices', 'MediaPlayer', 'QuickLook', 'CoreMotion', "Security"
    
    spec.dependency 'CentralX/CentralDb'
  end
  
  s.subspec 'CentralCategory' do |spec|
    spec.source_files = 'CentralX/CentralCategory/Classes/**/*'
    spec.public_header_files = 'CentralX/CentralCategory/Classes/*.h'
  end

  s.subspec 'CentralDb' do |spec|
    spec.source_files = 'CentralX/CentralDb/Classes/**/*'
    spec.public_header_files = 'CentralX/CentralDb/Classes/*.h'

    spec.libraries = 'sqlite3'
  end
  
  s.subspec 'CentralFile' do |spec|
    spec.source_files = 'CentralX/CentralFile/Classes/**/*'
    spec.public_header_files = 'CentralX/CentralFile/Classes/*.h'
  end
  
  s.subspec 'CentralHttp' do |spec|
    spec.source_files = 'CentralX/CentralHttp/Classes/**/*'
    spec.public_header_files = 'CentralX/CentralHttp/Classes/*.h'
    
    s.dependency 'AFNetworking', '~> 4.0'
  end
  
  s.subspec 'CentralPromise' do |spec|
    spec.source_files = 'CentralX/CentralPromise/Classes/**/*'
    spec.public_header_files = 'CentralX/CentralPromise/Classes/*.h'
  end
  
  s.subspec 'CentralRuntime' do |spec|
    spec.source_files = 'CentralX/CentralRuntime/Classes/**/*'
    spec.public_header_files = 'CentralX/CentralRuntime/Classes/*.h'
  end
  
  s.subspec 'CentralStream' do |spec|
    spec.source_files = 'CentralX/CentralStream/Classes/**/*'
    spec.public_header_files = 'CentralX/CentralStream/Classes/*.h'
  end
end
