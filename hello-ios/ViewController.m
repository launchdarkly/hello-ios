//
//  ViewController.m
//  hello-ios
//
//  Created by John Kodumal on 10/21/15.
//  Copyright © 2015 John Kodumal. All rights reserved.
//

#import "ViewController.h"
@import LaunchDarkly;

NSString * const MOBILE_KEY = @"";
NSString * const BOOLEAN_FLAG_KEY = @"hello-ios-boolean";
NSString * const NUMBER_FLAG_KEY = @"hello-ios-number";
NSString * const DOUBLE_FLAG_KEY = @"hello-ios-double";
NSString * const STRING_FLAG_KEY = @"hello-ios-string";
NSString * const ARRAY_FLAG_KEY = @"hello-ios-array";
NSString * const DICTIONARY_FLAG_KEY = @"hello-ios-dictionary";

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *booleanValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *doubleValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *stringValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrayValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *dictionaryValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *onlineLabel;
@property (weak, nonatomic) IBOutlet UISwitch *onlineSwitch;

@property (strong, nonatomic) NSArray<NSString*> *flagKeys;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.flagKeys = @[BOOLEAN_FLAG_KEY, NUMBER_FLAG_KEY, DOUBLE_FLAG_KEY, STRING_FLAG_KEY, ARRAY_FLAG_KEY, DICTIONARY_FLAG_KEY];
    
    [self setupLDClient];
    [self checkFeatureValue];
    [self checkOnlineStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupLDClient {
    LDUser *user = [[LDUser alloc] initWithKey:@"bob@example.com"];
    //optional user fields
    user.firstName = @"Bob";
    user.lastName = @"Loblaw";
    user.custom = @{@"groups": @[@"beta_testers"]};

    LDConfig *config = [[LDConfig alloc] initWithMobileKey:MOBILE_KEY];
//    config.streamingMode = NO;
//    config.flagPollingInterval = 30.0;

    __weak typeof(self) weakSelf = self;
    [[LDClient sharedInstance] observeKeys:self.flagKeys owner:self handler:^(NSDictionary<NSString *,LDChangedFlag *> * _Nonnull changedFlags) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        for (NSString* flagKey in changedFlags.allKeys) {
            [strongSelf featureFlagDidUpdate:flagKey];
        }
    }];
    [[LDClient sharedInstance] startWithConfig:config user:user];
}

- (void)checkBoolFeatureValue {
    BOOL boolFeature = [[LDClient sharedInstance] boolVariationForKey:BOOLEAN_FLAG_KEY fallback:NO];
    [self updateLabel:self.booleanValueLabel withText:boolFeature ? @"YES" : @"NO"];
}

- (void)checkNumberFeatureValue {
    NSInteger numberFeature = [[LDClient sharedInstance] integerVariationForKey:NUMBER_FLAG_KEY fallback:0];
    [self updateLabel:self.numberValueLabel withText:[NSString stringWithFormat:@"%ld",(long)numberFeature]];
}

- (void)checkDoubleFeatureValue {
    double doubleFeature = [[LDClient sharedInstance] doubleVariationForKey:DOUBLE_FLAG_KEY fallback:0.0];
    [self updateLabel:self.doubleValueLabel withText:[NSString stringWithFormat:@"%f",doubleFeature]];
}

- (void)checkStringFeatureValue {
    NSString *stringFeature = [[LDClient sharedInstance] stringVariationForKey:STRING_FLAG_KEY fallback:@"<no default>"];
    [self updateLabel:self.stringValueLabel withText:stringFeature];
}

- (void)checkArrayFeatureValue {
    NSArray *arrayFeature = [[LDClient sharedInstance] arrayVariationForKey:ARRAY_FLAG_KEY fallback:@[@0,@1]];
    [self updateLabel:self.arrayValueLabel withText:[arrayFeature componentsJoinedByString:@"\n"]];
}

- (void)checkDictionaryFeatureValue {
    NSDictionary *dictionaryFeature = [[LDClient sharedInstance] dictionaryVariationForKey:DICTIONARY_FLAG_KEY fallback:@{@"dictionary":@"fallback"}];
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
