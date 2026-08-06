#import "AppDelegate.h"
#import "hello_ios-Swift.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Set ExposureDedupeDemo.mobileKey in ExposureDedupeDemo.swift to your LaunchDarkly mobile key.
    [[ExposureDedupeDemo shared] startClientWithMobileKey:ExposureDedupeDemo.mobileKey];
    return YES;
}

@end
