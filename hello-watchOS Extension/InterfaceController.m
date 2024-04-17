#import "InterfaceController.h"
@import LaunchDarkly;

// Set FEATURE_FLAG_KEY to the feature flag key you want to evaluate.
NSString * const FEATURE_FLAG_KEY = @"sample-feature";

@interface InterfaceController ()
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *valueLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceSeparator *separator;

@end

@implementation InterfaceController

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    [self setupListener];
}

- (void)setupListener {
    __weak typeof(self) weakSelf = self;
    [[LDClient get] observe:FEATURE_FLAG_KEY owner:self handler:^(LDChangedFlag * _Nonnull changedFlag) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf updateUi:changedFlag.key result:changedFlag.newValue.boolValue];
    }];

    bool result = [[LDClient get] boolVariationForKey:FEATURE_FLAG_KEY defaultValue:false];
    [self updateUi:FEATURE_FLAG_KEY result:result];
}

- (void)updateUi:(NSString *)flagKey result:(bool)result {
    self.valueLabel.text = [NSString stringWithFormat:@"The %@ feature flag evaluates to %@", flagKey, result ? @"true" : @"false"];
}

@end
