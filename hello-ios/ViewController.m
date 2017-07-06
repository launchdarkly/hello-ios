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
NSString *BOOLEAN_FLAG_KEY = @"my-boolean";
NSString *NUMBER_FLAG_KEY = @"my-number";
NSString *STRING_FLAG_KEY = @"my-string";
NSString *ARRAY_FLAG_KEY = @"my-array";
NSString *DICTIONARY_FLAG_KEY = @"my-dictionary";

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
    
    [[LDClient sharedInstance] setDelegate:self];
    [[LDClient sharedInstance] start:config userBuilder:builder];
}

- (void)checkBoolFeatureValue {
    BOOL boolFeature = [[LDClient sharedInstance] boolVariation:BOOLEAN_FLAG_KEY fallback:NO];
    [self updateLabel:_booleanValueLabel withText:boolFeature ? @"YES" : @"NO"];
}

- (void)checkNumberFeatureValue {
    double numberFeature = [[LDClient sharedInstance] doubleVariation:NUMBER_FLAG_KEY fallback:0];
    [self updateLabel:_numberValueLabel withText:[NSString stringWithFormat:@"%f",numberFeature]];
}

- (void)checkStringFeatureValue {
    NSString *stringFeature = [[LDClient sharedInstance] stringVariation:STRING_FLAG_KEY fallback:@"<no default>"];
    [self updateLabel:_stringValueLabel withText:stringFeature];
}

- (void)checkArrayFeatureValue {
    NSArray *arrayFeature = [[LDClient sharedInstance] arrayVariation:ARRAY_FLAG_KEY fallback:[NSArray array]];
    [self updateLabel:_arrayValueLabel withText:[arrayFeature componentsJoinedByString:@"\n"]];
}

- (void)checkDictionaryFeatureValue {
    NSDictionary *dictionaryFeature = [[LDClient sharedInstance] dictionaryVariation:DICTIONARY_FLAG_KEY fallback:[NSDictionary dictionary]];
    NSMutableArray *elems = [NSMutableArray arrayWithCapacity:dictionaryFeature.count];
    [dictionaryFeature enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [elems addObject:[NSString stringWithFormat:@"\"%@\": %@", key, obj]];
    }];
    [self updateLabel:_dictionaryValueLabel withText:[elems componentsJoinedByString:@"\n"]];
}

- (void)checkFeatureValue {
    [self checkBoolFeatureValue];
    [self checkNumberFeatureValue];
    [self checkStringFeatureValue];
    [self checkArrayFeatureValue];
    [self checkDictionaryFeatureValue];
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
    } else if([key isEqualToString:STRING_FLAG_KEY]) {
        [self checkStringFeatureValue];
    } else if([key isEqualToString:ARRAY_FLAG_KEY]) {
        [self checkArrayFeatureValue];
    } else if([key isEqualToString:DICTIONARY_FLAG_KEY]) {
        [self checkDictionaryFeatureValue];
    }
}

@end
