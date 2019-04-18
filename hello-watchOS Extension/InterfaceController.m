//
//  InterfaceController.m
//  hello-watchOS Extension
//
//  Created by Danial Zahid on 4/6/17.
//  Copyright © 2017 John Kodumal. All rights reserved.
//

#import "InterfaceController.h"
@import LaunchDarkly;

NSString *MOBILE_KEY = @"";
NSString *FLAG_KEY = @"test-flag";

@interface InterfaceController () <ClientDelegate>
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *valueLabel;

@end

@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    [LDClient sharedInstance].delegate = self;
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    [self setupLDClient];
    [self checkFeatureValue];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (void)setupLDClient {
    LDUserBuilder *builder = [[LDUserBuilder alloc] init];
    builder.key = @"bob@example.com";
    builder.firstName = @"Bob";
    builder.lastName = @"Loblaw";
    
    NSArray *groups = @[@"beta_testers"];
    [builder customArray:@"groups" value:groups];
    
    LDConfig *config = [[LDConfig alloc] initWithMobileKey:MOBILE_KEY];
    
    [[LDClient sharedInstance] start:config withUserBuilder:builder];
}

- (void)checkFeatureValue {
    BOOL showFeature = [[LDClient sharedInstance] boolVariation:FLAG_KEY fallback:NO];
    [self updateLabel:[NSString stringWithFormat:@"%d",showFeature]];
}

- (void)updateLabel:(NSString *)value {
    self.valueLabel.text = [NSString stringWithFormat:@"Flag value: %@",value];
}

-(void)featureFlagDidUpdate:(NSString *)key {
    if([key isEqualToString:FLAG_KEY]) {
        [self checkFeatureValue];
    }
}

@end



