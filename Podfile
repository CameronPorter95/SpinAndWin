# Uncomment the next line to define a global platform for your project
 platform :ios, '13.0'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
      config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf'
      if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 9.0
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
      end
    end
  end
end

def shared_pods
  use_frameworks!
  inhibit_all_warnings!

  pod 'BrightFutures'
  pod 'DynamicColor'
  pod 'Japx'
  pod "Macaw", "0.9.9"
  pod 'Moya'
  pod 'R.swift'
  pod 'SwiftyJSON'
end

target 'SpinAndWin' do
  shared_pods
end
