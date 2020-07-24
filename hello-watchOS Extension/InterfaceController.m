//
//  InterfaceController.m
//  hello-watchOS Extension
//
//  Copyright © 2017 John Kodumal. All rights reserved.
//

#import "InterfaceController.h"
@import LaunchDarkly;

NSString * const FLAG_KEY = @"test-flag";

@interface InterfaceController ()
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *valueLabel;

@property (strong, nonatomic) NSArray<NSString*> *flagKeys;

@end

@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];

    self.flagKeys = @[FLAG_KEY];
    [self registerLDClientObservers];
    [self checkFeatureValue];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (void)registerLDClientObservers {
    __weak typeof(self) weakSelf = self;
    [[LDClient get] observeKeys:self.flagKeys owner:self handler:^(NSDictionary<NSString *,LDChangedFlag *> * _Nonnull changedFlags) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        for (NSString* flagKey in changedFlags.allKeys) {
            [strongSelf featureFlagDidUpdate:flagKey];
        }
    }];
}

- (void)checkFeatureValue {
    BOOL showFeature = [[LDClient get] boolVariationForKey:FLAG_KEY defaultValue:NO];
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



