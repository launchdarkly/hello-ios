//
//  ViewController.m
//  hello-ios
//
//  Created by John Kodumal on 10/21/15.
//  Copyright © 2015 John Kodumal. All rights reserved.
//

#import "ViewController.h"
#import "LDClient.h"
#import "LDConfig.h"
#import "LDUserBuilder.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    LDUserBuilder *builder = [[LDUserBuilder alloc] init];
    builder = [builder withKey:@"bob@example.com"];
    builder = [builder withFirstName:@"Bob"];
    builder = [builder withLastName:@"Loblaw"];
    
    NSArray *groups = @[@"beta_testers"];
    builder = [builder withCustomArray:@"groups" value:groups];
    
    User *user = [builder build];

    LDConfigBuilder *config = [[LDConfigBuilder alloc] init];
    [config withApiKey:@"YOUR_MOBILE_KEY"];
    
    [[LDClient sharedInstance] start:[config build] user:user];
    
    BOOL showFeature = [[LDClient sharedInstance] toggle:@"YOUR_FLAG_KEY" default:NO];
    if (showFeature) {
        NSLog(@"Showing feature for %@", user.key);
    } else {
        NSLog(@"Not showing feature for %@", user.key);
    }


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
