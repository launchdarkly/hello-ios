//
//  ViewController.m
//  hello-ios
//
//  Created by John Kodumal on 10/21/15.
//  Copyright © 2015 John Kodumal. All rights reserved.
//

#import "ViewController.h"
#import "LDClient.h"

@interface ViewController ()

@property LDUserModel *user;
@end

@implementation ViewController
@synthesize user;

- (void)viewDidLoad {
    [super viewDidLoad];
    LDUserBuilder *builder = [[LDUserBuilder alloc] init];
    builder = [builder withKey:@"bob@example.com"];
    builder = [builder withFirstName:@"Bob"];
    builder = [builder withLastName:@"Loblaw"];
    
    user = [builder build];
    
    NSArray *groups = @[@"beta_testers"];
    builder = [builder withCustomArray:@"groups" value:groups];
    
    LDConfigBuilder *config = [[LDConfigBuilder alloc] init];
    [config withApiKey:@"YOUR_MOBILE_KEY"];
    
    [[LDClient sharedInstance] start:config userBuilder:builder];
    
    [NSTimer scheduledTimerWithTimeInterval:2.0
                                     target:self
                                   selector:@selector(checkFeatureValue)
                                   userInfo:nil
                                    repeats:YES];
    
}

-(void) checkFeatureValue {
    BOOL showFeature = [[LDClient sharedInstance] toggle:@"YOUR_FLAG_KEY" default:NO];
    if (showFeature) {
        NSLog(@"Showing feature for %@", user.key);
    } else {
        NSLog(@"Not showing feature for user %@", user.key);
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
