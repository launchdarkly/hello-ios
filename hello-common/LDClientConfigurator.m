//
//  LDClientConfigurator.m
//  hello-ios
//
//  Copyright © 2019 John Kodumal. All rights reserved.
//

#import "LDClientConfigurator.h"
@import LaunchDarkly;

NSString * const launchDarklyMobileKey = @"";

@implementation LDClientConfigurator
+(void)setupLDClient {
    LDContextBuilder *builder = [[LDContextBuilder alloc] initWithKey:@"test@email.com"];
    [builder trySetValueWithName:@"firstName" value:[LDValue ofString:@"Bob"]];
    [builder trySetValueWithName:@"lastName" value:[LDValue ofString:@"Loblaw"]];

    NSArray *groups = [NSArray arrayWithObjects:[LDValue ofString:@"beta_testers"], nil];
    [builder trySetValueWithName:@"groups" value:[LDValue ofArray:groups]];

    ContextBuilderResult *result = [builder build];

    if (result.success) {
        LDConfig *config = [[LDConfig alloc] initWithMobileKey:launchDarklyMobileKey];
        config.flagPollingInterval = 30.0;

        [LDClient startWithConfiguration:config context:result.success completion: nil];
    }
}

@end
