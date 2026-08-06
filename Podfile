use_frameworks!
target 'hello-ios' do
    platform :ios, '13.0'
    # Points at the evaluation-exposure-dedupe branch until that work is released.
    # After release, switch back to: pod 'LaunchDarkly', '>= 11.x'
    pod 'LaunchDarkly', :git => 'https://github.com/launchdarkly/ios-client-sdk.git', :branch => 'andrey/flag-exposure-dedupe'
end

target 'hello-watchOS Extension' do
    platform :watchos, '6.0'
    pod 'LaunchDarkly', :git => 'https://github.com/launchdarkly/ios-client-sdk.git', :branch => 'andrey/flag-exposure-dedupe'
end

# CocoaPods resets the target's base xcconfig on integrate; keep our wrappers that
# include both the Pods settings and the local Secrets.xcconfig.
post_integrate do |installer|
  project_path = File.join(installer.sandbox.root.parent, 'hello-ios.xcodeproj')
  project = Xcodeproj::Project.open(project_path)
  target = project.targets.find { |t| t.name == 'hello-ios' }
  next unless target

  debug_ref = project.files.find { |f| f.path == 'hello-ios/Debug.xcconfig' }
  release_ref = project.files.find { |f| f.path == 'hello-ios/Release.xcconfig' }
  next unless debug_ref && release_ref

  target.build_configurations.each do |config|
    config.base_configuration_reference = config.name == 'Debug' ? debug_ref : release_ref
  end
  project.save
end
