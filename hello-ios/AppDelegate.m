#import "AppDelegate.h"
#import "LDClientConfigurator.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [LDClientConfigurator setupLDClient];

    return YES;
}

@end
