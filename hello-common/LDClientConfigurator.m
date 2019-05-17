//
//  LDClientConfigurator.m
//  hello-ios
//
//  Created by Mark Pokorny on 5/15/19. +JMJ
//  Copyright © 2019 John Kodumal. All rights reserved.
//

#import "LDClientConfigurator.h"
@import LaunchDarkly;

NSString *launchDarklyMobileKey = @"";

@implementation LDClientConfigurator
+(void)setupLDClient {
    LDUserBuilder *userBuilder = [[LDUserBuilder alloc] init];
    userBuilder.key = @"bob@example.com";
    //optional user fields
    userBuilder.firstName = @"Bob";
    userBuilder.lastName = @"Loblaw";
    [userBuilder customArray:@"groups" value:@[@"beta_testers"]];

    LDConfig *config = [[LDConfig alloc] initWithMobileKey:launchDarklyMobileKey];

    [[LDClient sharedInstance] start:config withUserBuilder:userBuilder];
}
@end
