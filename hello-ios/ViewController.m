#import "ViewController.h"
@import LaunchDarkly;

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@property (strong, nonatomic) NSString* featureFlagKey;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Set featureFlagKey to the feature flag key you want to evaluate.
    self.featureFlagKey = @"sample-feature";
    [self setupListener];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)setupListener {
    __weak typeof(self) weakSelf = self;
    [[LDClient get] observe:self.featureFlagKey owner:self handler:^(LDChangedFlag * _Nonnull changedFlag) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf updateUi:changedFlag.key result:changedFlag.newValue.boolValue];
    }];

    bool result = [[LDClient get] boolVariationForKey:self.featureFlagKey defaultValue:false];
    [self updateUi:self.featureFlagKey result:result];
}

- (void)updateUi:(NSString *)flagKey result:(bool)result {
    self.valueLabel.text = [NSString stringWithFormat:@"The %@ feature flag evaluates to %@", flagKey, result ? @"true" : @"false"];

    UIColor *toggleOn = [[UIColor alloc] initWithRed:0 green:0.52 blue:0.29 alpha:1 ];
    UIColor *toggleOff = [[UIColor alloc] initWithRed:0.22 green:0.22 blue:0.25 alpha:1 ];

    self.view.backgroundColor = result ? toggleOn : toggleOff;
}

@end
