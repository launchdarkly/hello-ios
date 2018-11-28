//
//  ViewController.m
//  hello-ios
//
//  Created by John Kodumal on 10/21/15.
//  Copyright © 2015 John Kodumal. All rights reserved.
//

#import "ViewController.h"
#import "Darkly.h"

NSString *MOBILE_KEY = @"";
NSString *BOOLEAN_FLAG_KEY = @"hello-ios-boolean";
NSString *NUMBER_FLAG_KEY = @"hello-ios-number";
NSString *DOUBLE_FLAG_KEY = @"hello-ios-double";
NSString *STRING_FLAG_KEY = @"hello-ios-string";
NSString *ARRAY_FLAG_KEY = @"hello-ios-array";
NSString *DICTIONARY_FLAG_KEY = @"hello-ios-dictionary";

@interface ViewController () <ClientDelegate>

@property (weak, nonatomic) IBOutlet UILabel *booleanValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *doubleValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *stringValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrayValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *dictionaryValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *onlineLabel;
@property (weak, nonatomic) IBOutlet UISwitch *onlineSwitch;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupLDClient];
    [self checkFeatureValue];
    [self checkOnlineStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupLDClient {
    LDUserBuilder *userBuilder = [[LDUserBuilder alloc] init];
    userBuilder.key = @"bob@example.com";
    //optional user fields
    userBuilder.firstName = @"Bob";
    userBuilder.lastName = @"Loblaw";
    [userBuilder customArray:@"groups" value:@[@"beta_testers"]];
    
    LDConfig *config = [[LDConfig alloc] initWithMobileKey:MOBILE_KEY];

    [[LDClient sharedInstance] setDelegate:self];
    [[LDClient sharedInstance] start:config withUserBuilder:userBuilder];
}

- (void)checkBoolFeatureValue {
    BOOL boolFeature = [[LDClient sharedInstance] boolVariation:BOOLEAN_FLAG_KEY fallback:NO];
    [self updateLabel:self.booleanValueLabel withText:boolFeature ? @"YES" : @"NO"];
}

- (void)checkNumberFeatureValue {
    NSInteger numberFeature = [[[LDClient sharedInstance] numberVariation:NUMBER_FLAG_KEY fallback:@0] integerValue];
    [self updateLabel:self.numberValueLabel withText:[NSString stringWithFormat:@"%ld",(long)numberFeature]];
}

- (void)checkDoubleFeatureValue {
    double doubleFeature = [[LDClient sharedInstance] doubleVariation:DOUBLE_FLAG_KEY fallback:0.0];
    [self updateLabel:self.doubleValueLabel withText:[NSString stringWithFormat:@"%f",doubleFeature]];
}

- (void)checkStringFeatureValue {
    NSString *stringFeature = [[LDClient sharedInstance] stringVariation:STRING_FLAG_KEY fallback:@"<no default>"];
    [self updateLabel:self.stringValueLabel withText:stringFeature];
}

- (void)checkArrayFeatureValue {
    NSArray *arrayFeature = [[LDClient sharedInstance] arrayVariation:ARRAY_FLAG_KEY fallback:@[@0,@1]];
    [self updateLabel:self.arrayValueLabel withText:[arrayFeature componentsJoinedByString:@"\n"]];
}

- (void)checkDictionaryFeatureValue {
    NSDictionary *dictionaryFeature = [[LDClient sharedInstance] dictionaryVariation:DICTIONARY_FLAG_KEY fallback:@{@"dictionary":@"fallback"}];
    NSMutableArray *elems = [NSMutableArray arrayWithCapacity:dictionaryFeature.count];
    [dictionaryFeature enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [elems addObject:[NSString stringWithFormat:@"\"%@\": %@", key, obj]];
    }];
    [self updateLabel:self.dictionaryValueLabel withText:[elems componentsJoinedByString:@"\n"]];
}

- (void)checkFeatureValue {
    [self checkBoolFeatureValue];
    [self checkNumberFeatureValue];
    [self checkDoubleFeatureValue];
    [self checkStringFeatureValue];
    [self checkArrayFeatureValue];
    [self checkDictionaryFeatureValue];
}

- (void)checkOnlineStatus {
    self.onlineLabel.text = [LDClient sharedInstance].isOnline ? @"Online" : @"Offline";
    self.onlineSwitch.on = [LDClient sharedInstance].isOnline;
}

- (void)updateLabel:(UILabel *)label withText:(NSString *)value {
    if (value == nil) {
        value = @"<nil>";
    } else if (value.length == 0) {
        value = @" ";
    }
    label.text = value;
}

#pragma mark - ClientDelegate methods

-(void)featureFlagDidUpdate:(NSString *)key {
    if([key isEqualToString:BOOLEAN_FLAG_KEY]) {
        [self checkBoolFeatureValue];
    } else if([key isEqualToString:NUMBER_FLAG_KEY]) {
        [self checkNumberFeatureValue];
    } else if([key isEqualToString:DOUBLE_FLAG_KEY]) {
        [self checkDoubleFeatureValue];
    } else if([key isEqualToString:STRING_FLAG_KEY]) {
        [self checkStringFeatureValue];
    } else if([key isEqualToString:ARRAY_FLAG_KEY]) {
        [self checkArrayFeatureValue];
    } else if([key isEqualToString:DICTIONARY_FLAG_KEY]) {
        [self checkDictionaryFeatureValue];
    }
}

#pragma mark - IBActions

- (IBAction)onlineSwitchValueChanged:(UISwitch *)sender {
    [LDClient sharedInstance].online = sender.on;
    [self checkOnlineStatus];
}

@end
