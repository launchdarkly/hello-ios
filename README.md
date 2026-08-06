# LaunchDarkly sample iOS application

We've built a simple mobile application that demonstrates how LaunchDarkly's SDK works.

Below, you'll find the build procedure. For more comprehensive instructions, you can visit your [Quickstart page](https://app.launchdarkly.com/quickstart#/) or the [iOS reference guide](https://docs.launchdarkly.com/sdk/client-side/ios).

## Build instructions

1. Make sure you have [Xcode](https://itunes.apple.com/us/app/xcode/id497799835?ls=1&mt=12) installed
1. Copy `Secrets.xcconfig.example` to `Secrets.xcconfig` and set `mobileKey` to your LaunchDarkly mobile key (`Secrets.xcconfig` is gitignored)
1. Make sure you're in this directory and then type `pod install`
1. Open `hello-ios.xcworkspace` in Xcode
1. If there is an existing boolean feature flag in your LaunchDarkly project that you want to evaluate, set `featureFlagKey` in `hello-ios/ViewController.m` and `hello-watchOS Extension/InterfaceController.m` to the flag key. watchOS still uses `sdkKey` in `hello-common/LDClientConfigurator.m`.

```xcconfig
    // Secrets.xcconfig
    mobileKey = your-mobile-key
```

```objc
    // hello-ios/ViewController.m
    self.featureFlagKey = @"sample-feature";

    // hello-watchOS Extension/InterfaceController.m
    NSString * const FEATURE_FLAG_KEY = @"sample-feature";
```

You should see the message "The <flagKey> feature flag evaluates to <flagValue>.". The application will run continuously and react to the flag changes in LaunchDarkly.

## Verifying evaluation exposure deduplication

The iOS target registers two hooks with different dedupe windows (5s and 10s), using the same per-hook API a customer would:

```swift
config.hooks = [
    ExposureCountingHook(label: "fast", window: 5, onStage: ...),
    ExposureCountingHook(label: "slow", window: 10, onStage: ...),
]
```

Each hook declares `evaluationExposureDeduper` on itself. Tap **Evaluate Flag** repeatedly: "Evaluations requested" climbs while each hook's count stays put until its window elapses. Tap **Identify** (leave the user key empty to re-identify the same context) to clear both caches so the next evaluation reaches both hooks again.
