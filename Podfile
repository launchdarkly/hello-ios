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
