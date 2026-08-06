#import "ViewController.h"
#import "hello_ios-Swift.h"
@import LaunchDarkly;

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (strong, nonatomic) UILabel *dedupeStatusLabel;
@property (strong, nonatomic) UITextField *userKeyField;
@property (strong, nonatomic) NSString *featureFlagKey;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Set featureFlagKey to the feature flag key you want to evaluate.
    self.featureFlagKey = @"sample-feature";
    [self setupDedupeUI];
    [self setupListener];
}

- (void)setupDedupeUI {
    self.dedupeStatusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.dedupeStatusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.dedupeStatusLabel.numberOfLines = 0;
    self.dedupeStatusLabel.textAlignment = NSTextAlignmentCenter;
    self.dedupeStatusLabel.font = [UIFont monospacedDigitSystemFontOfSize:13 weight:UIFontWeightRegular];
    self.dedupeStatusLabel.textColor = [[UIColor alloc] initWithWhite:0.9 alpha:1];
    [self.view addSubview:self.dedupeStatusLabel];

    self.userKeyField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.userKeyField.translatesAutoresizingMaskIntoConstraints = NO;
    self.userKeyField.placeholder = @"User key (empty = default)";
    self.userKeyField.borderStyle = UITextBorderStyleRoundedRect;
    self.userKeyField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.userKeyField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.userKeyField.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.userKeyField];

    UIButton *evaluateButton = [UIButton buttonWithType:UIButtonTypeSystem];
    evaluateButton.translatesAutoresizingMaskIntoConstraints = NO;
    [evaluateButton setTitle:@"Evaluate Flag" forState:UIControlStateNormal];
    evaluateButton.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
    [evaluateButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [evaluateButton addTarget:self action:@selector(evaluateTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:evaluateButton];

    UIButton *identifyButton = [UIButton buttonWithType:UIButtonTypeSystem];
    identifyButton.translatesAutoresizingMaskIntoConstraints = NO;
    [identifyButton setTitle:@"Identify" forState:UIControlStateNormal];
    identifyButton.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
    [identifyButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [identifyButton addTarget:self action:@selector(identifyTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:identifyButton];

    [NSLayoutConstraint activateConstraints:@[
        [self.dedupeStatusLabel.leadingAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.leadingAnchor],
        [self.dedupeStatusLabel.trailingAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.trailingAnchor],
        [self.dedupeStatusLabel.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:16],

        [evaluateButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [evaluateButton.bottomAnchor constraintEqualToAnchor:self.userKeyField.topAnchor constant:-16],

        [self.userKeyField.leadingAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.leadingAnchor],
        [self.userKeyField.trailingAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.trailingAnchor],
        [self.userKeyField.bottomAnchor constraintEqualToAnchor:identifyButton.topAnchor constant:-12],

        [identifyButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [identifyButton.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-24],
    ]];

    __weak typeof(self) weakSelf = self;
    [[ExposureDedupeDemo shared] setStatusHandler:^(NSString *status) {
        weakSelf.dedupeStatusLabel.text = status;
    }];
}

- (void)setupListener {
    __weak typeof(self) weakSelf = self;
    [[LDClient get] observe:self.featureFlagKey owner:self handler:^(LDChangedFlag * _Nonnull changedFlag) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf updateUi:changedFlag.key result:changedFlag.newValue.boolValue];
    }];

    bool result = [[ExposureDedupeDemo shared] evaluateWithFlagKey:self.featureFlagKey];
    [self updateUi:self.featureFlagKey result:result];
}

- (void)evaluateTapped {
    bool result = [[ExposureDedupeDemo shared] evaluateWithFlagKey:self.featureFlagKey];
    [self updateUi:self.featureFlagKey result:result];
}

- (void)identifyTapped {
    NSString *resolved = [[ExposureDedupeDemo shared] identifyWithUserKey:self.userKeyField.text ?: @""];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Identified"
                                                                   message:[NSString stringWithFormat:@"Identified \"%@\", dedupe caches cleared", resolved]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)updateUi:(NSString *)flagKey result:(bool)result {
    self.valueLabel.text = [NSString stringWithFormat:@"The %@ feature flag evaluates to %@", flagKey, result ? @"true" : @"false"];

    UIColor *toggleOn = [[UIColor alloc] initWithRed:0 green:0.52 blue:0.29 alpha:1 ];
    UIColor *toggleOff = [[UIColor alloc] initWithRed:0.22 green:0.22 blue:0.25 alpha:1 ];

    self.view.backgroundColor = result ? toggleOn : toggleOff;
}

@end
