//
//  ViewController.m
//  hello-ios
//
//  Created by John Kodumal on 10/21/15.
//  Copyright © 2015 John Kodumal. All rights reserved.
//

#import "ViewController.h"
#import "LDClient.h"

NSString *MOBILE_KEY = @"";
NSString *FLAG_KEY = @"";

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
    builder = [builder withKey:@"bob@example.com"];
    builder = [builder withFirstName:@"Bob"];
    builder = [builder withLastName:@"Loblaw"];
    
    NSArray *groups = @[@"beta_testers"];
    builder = [builder withCustomArray:@"groups" value:groups];
    
    LDConfigBuilder *config = [[LDConfigBuilder alloc] init];
    [config withMobileKey:MOBILE_KEY];
    
    [[LDClient sharedInstance] start:config userBuilder:builder];
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
