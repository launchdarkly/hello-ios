# LaunchDarkly sample iOS application

We've built a simple mobile application that demonstrates how LaunchDarkly's SDK works.

Below, you'll find the build procedure. For more comprehensive instructions, you can visit your [Quickstart page](https://app.launchdarkly.com/quickstart#/) or the [iOS reference guide](https://docs.launchdarkly.com/sdk/client-side/ios).

## Build instructions

1. Make sure you have [Xcode](https://itunes.apple.com/us/app/xcode/id497799835?ls=1&mt=12) installed
1. Make sure you're in this directory and then type `pod install`
1. Open `hello-ios.xcworkspace` in XCode
1. Set the value of `sdkKey` in `hello-common/LDClientConfigurator.m` to your LaunchDarkly mobile key. If there is an existing boolean feature flag in your LaunchDarkly project that you want to evaluate, set `featureFlagKey` in `hello-ios/ViewController.m` and `hello-watchOS Extension/InterfaceController.m` to the flag key.

```swift
    // hello-common/LDClientConfigurator.m
    NSString * const sdkKey = @"";

    // hello-ios/ViewController.m
    self.featureFlagKey = @"sample-feature";

    // hello-watchOS Extension/InterfaceController.m
    NSString * const FEATURE_FLAG_KEY = @"sample-feature";
```

You should see the message "The <flagKey> feature flag evaluates to <flagValue>.", the application will run continuously and react to the flag changes in LaunchDarkly.
