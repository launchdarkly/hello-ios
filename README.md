### LaunchDarkly Sample iOS Application
We've built a simple console application that demonstrates how LaunchDarkly's SDK works. 
Below, you'll find the basic build procedure, but for more comprehensive instructions, you can visit your [Quickstart page](https://app.launchdarkly.com/quickstart#/).
##### Build instructions

1. Make sure you have [XCode](https://itunes.apple.com/us/app/xcode/id497799835?ls=1&mt=12) and [CocoaPods](https://cocoapods.org) installed
2. Make sure you're in this directory and then type `pod install`
3. Open `hello-ios.xcworkspace` in XCode
4. Copy the mobile key from your account settings page and the feature flag key(s) from your LaunchDarkly dashboard into `LDClientConfigurator.m`
5. Run your application through XCode
