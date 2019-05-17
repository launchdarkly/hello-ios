//
//  LDClientConfigurator.m
//  hello-ios
//
//  Created by Mark Pokorny on 5/15/19. +JMJ
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
    user.custom = @{@"groups": @[@"beta_testers"]};

    LDConfig *config = [[LDConfig alloc] initWithMobileKey:launchDarklyMobileKey];
    config.flagPollingInterval = 30.0;

    [[LDClient sharedInstance] startWithConfig:config user:user];
}

@end
