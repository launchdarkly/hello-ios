#import "AppDelegate.h"
#import "hello_ios-Swift.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSString *mobileKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"mobileKey"];
    if (mobileKey.length == 0) {
        [NSException raise:NSInternalInconsistencyException
                    format:@"Missing mobileKey in Info.plist. Copy Secrets.xcconfig.example to Secrets.xcconfig and set mobileKey."];
    }
    [[ExposureDedupeDemo shared] startClientWithMobileKey:mobileKey];
    return YES;
}

@end
