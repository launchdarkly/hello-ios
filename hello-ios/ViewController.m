//
//  ViewController.m
//  hello-ios
//
//  Copyright © 2015 John Kodumal. All rights reserved.
//

#import "ViewController.h"
@import LaunchDarkly;

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

    [self registerLDClientObservers];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self checkFeatureValue];
    [self checkOnlineStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)registerLDClientObservers {
    __weak typeof(self) weakSelf = self;
    [[LDClient get] observeKeys:self.flagKeys owner:self handler:^(NSDictionary<NSString *,LDChangedFlag *> * _Nonnull changedFlags) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        for (NSString* flagKey in changedFlags.allKeys) {
            [strongSelf featureFlagDidUpdate:flagKey];
        }
    }];
    [[LDClient get] observeFlagsUnchangedWithOwner:self handler:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf setOnlineLabel];
    }];
}

- (void)checkBoolFeatureValue {
    BOOL boolFeature = [[LDClient get] boolVariationForKey:BOOLEAN_FLAG_KEY defaultValue:NO];
    [self updateLabel:self.booleanValueLabel withText:boolFeature ? @"YES" : @"NO"];
}

- (void)checkNumberFeatureValue {
    NSInteger numberFeature = [[LDClient get] integerVariationForKey:NUMBER_FLAG_KEY defaultValue:0];
    [self updateLabel:self.numberValueLabel withText:[NSString stringWithFormat:@"%ld",(long)numberFeature]];
}

- (void)checkDoubleFeatureValue {
    double doubleFeature = [[LDClient get] doubleVariationForKey:DOUBLE_FLAG_KEY defaultValue:0.0];
    [self updateLabel:self.doubleValueLabel withText:[NSString stringWithFormat:@"%f",doubleFeature]];
}

- (void)checkStringFeatureValue {
    NSString *stringFeature = [[LDClient get] stringVariationForKey:STRING_FLAG_KEY defaultValue:@"<no default>"];
    [self updateLabel:self.stringValueLabel withText:stringFeature];
}

- (void)checkArrayFeatureValue {
    NSArray *arrayFeature = [[LDClient get] arrayVariationForKey:ARRAY_FLAG_KEY defaultValue:@[@0,@1]];
    [self updateLabel:self.arrayValueLabel withText:[arrayFeature componentsJoinedByString:@"\n"]];
}

- (void)checkDictionaryFeatureValue {
    NSDictionary *dictionaryFeature = [[LDClient get] dictionaryVariationForKey:DICTIONARY_FLAG_KEY defaultValue:@{@"dictionary":@"fallback"}];
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
    [self setOnlineLabel];
    self.onlineSwitch.on = [LDClient get].isOnline;
}

- (void)setOnlineLabel {
    self.onlineLabel.text = [LDClient get].isOnline ? @"Online" : @"Offline";
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
    [self setOnlineLabel];
}

-(void)userUnchanged {
    [self setOnlineLabel];
}

#pragma mark - IBActions

- (IBAction)onlineSwitchValueChanged:(UISwitch *)sender {
    [[LDClient get] setOnline:sender.on];
    [self setOnlineLabel];
}

@end
