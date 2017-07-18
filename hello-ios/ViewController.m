//
//  ViewController.m
//  hello-ios
//
//  Created by John Kodumal on 10/21/15.
//  Copyright © 2015 John Kodumal. All rights reserved.
//

#import "ViewController.h"
#import "Darkly.h"

NSString *MOBILE_KEY = @"mob-b9b5e098-aa3d-4049-b8fe-64abc39cd7d9";
NSString *FLAG_KEY = @"main-slider";

@interface ViewController () <ClientDelegate>

@property LDUserModel *user;
@end

@implementation ViewController
@synthesize user;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupLDClient];
    [self checkFeatureValue];
    [LDClient sharedInstance].delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupLDClient {
    LDUserBuilder *builder = [[LDUserBuilder alloc] init];
    builder.key = @"bob@example.com";
    builder.firstName = @"Bob";
    builder.lastName = @"Loblaw";
    
    NSArray *groups = @[@"beta_testers"];
    [builder customArray:@"groups" value:groups];
    
    LDConfig *config = [[LDConfig alloc] initWithMobileKey:MOBILE_KEY];
    config.debugEnabled = YES;
    
    [[LDClient sharedInstance] start:config withUserBuilder:builder];
}

- (void)checkFeatureValue {
    BOOL showFeature = [[LDClient sharedInstance] boolVariation:FLAG_KEY fallback:NO];
    [self updateLabel:[NSString stringWithFormat:@"%d",showFeature]];
}

- (void)updateLabel:(NSString *)value {
    self.valueLabel.text = [NSString stringWithFormat:@"Flag value: %@",value];
}

#pragma mark - ClientDelegate methods

-(void)featureFlagDidUpdate:(NSString *)key {
    if([key isEqualToString:FLAG_KEY]) {
        [self checkFeatureValue];
    }
}

@end
