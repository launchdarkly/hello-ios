#import "LDClientConfigurator.h"
@import LaunchDarkly;

// Set sdkKey to your LaunchDarkly mobile key.
NSString * const sdkKey = @"";

@implementation LDClientConfigurator
+(void)setupLDClient {
    // Set up the evaluation context. This context should appear on your
    // LaunchDarkly contexts dashboard soon after you run the demo.
    LDContextBuilder *builder = [[LDContextBuilder alloc] initWithKey:@"example-user-key"];
    [builder kindWithKind:@"user"];
    [builder nameWithName:@"Sandy"];

    ContextBuilderResult *result = [builder build];

    if (result.success) {
        LDConfig *config = [[LDConfig alloc]
                            initWithMobileKey:sdkKey autoEnvAttributes:true];

        [LDClient startWithConfiguration:config context:result.success completion: nil];
    }
}

@end
