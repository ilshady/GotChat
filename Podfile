# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'GotChat' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  inhibit_all_warnings!

  # Pods for GotChat
  pod "EasyPeasy"
  pod 'Firebase/Database'
  pod 'Firebase/Auth'
  pod 'Firebase/Storage'

  pod 'MBProgressHUD', '~> 1.2.0'
end

post_install do |pi|
    pi.pods_project.targets.each do |t|
      t.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
      end
    end
end
