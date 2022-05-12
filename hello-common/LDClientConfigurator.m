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
    LDUser *user = [[LDUser alloc] initWithKey:@"bob@example.com"];
    //optional user fields
    user.firstName = @"Bob";
    user.lastName = @"Loblaw";
    user.custom = @{@"groups": [LDValue ofString:@"beta_testers"]};

    LDConfig *config = [[LDConfig alloc] initWithMobileKey:launchDarklyMobileKey];
    config.flagPollingInterval = 30.0;

    [LDClient startWithConfiguration:config user:user completion: nil];
}

@end
