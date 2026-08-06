import Foundation
import LaunchDarkly

/// Owns the two example hooks and starts the LaunchDarkly client the way a customer would:
/// each hook carries its own `evaluationExposureDeduper`.
@objc public final class ExposureDedupeDemo: NSObject {
    @objc public static let shared = ExposureDedupeDemo()

    // Two hooks with different windows, to show that each one is deduplicated on its own.
    // TimeInterval is seconds on iOS (Android uses milliseconds).
    private static let fastWindow: TimeInterval = 5
    private static let slowWindow: TimeInterval = 10
    private static let defaultUserKey = "example-user-key"

    private var fastHook: ExposureCountingHook!
    private var slowHook: ExposureCountingHook!
    private var evaluationsRequested = 0
    private var statusHandler: ((String) -> Void)?

    private override init() {
        super.init()
    }

    /// Starts the client with two independently-deduplicated hooks. Call once from AppDelegate.
    @objc public func startClient(mobileKey: String) {
        fastHook = ExposureCountingHook(label: "fast", window: Self.fastWindow) { [weak self] in
            self?.publishStatus()
        }
        slowHook = ExposureCountingHook(label: "slow", window: Self.slowWindow) { [weak self] in
            self?.publishStatus()
        }

        var config = LDConfig(mobileKey: mobileKey, autoEnvAttributes: .enabled)
        // Same shape a customer uses: each hook declares its own deduper.
        config.hooks = [fastHook, slowHook]

        var builder = LDContextBuilder(key: Self.defaultUserKey)
        builder.kind("user")
        builder.name("Sandy")
        guard case .success(let context) = builder.build() else {
            return
        }

        LDClient.start(config: config, context: context, startWaitSeconds: 5)
        publishStatus()
    }

    @objc public func setStatusHandler(_ handler: @escaping (String) -> Void) {
        statusHandler = handler
        publishStatus()
    }

    @objc public func evaluate(flagKey: String) -> Bool {
        evaluationsRequested += 1
        let value = LDClient.get()?.boolVariation(forKey: flagKey, defaultValue: false) ?? false
        publishStatus()
        return value
    }

    /// Identifies to `userKey`, or the default key when empty — empty keys are invalid and would
    /// skip the dedupe-cache reset the demo is meant to show.
    @objc public func identify(userKey: String) -> String {
        let key = userKey.trimmingCharacters(in: .whitespacesAndNewlines)
        let resolved = key.isEmpty ? Self.defaultUserKey : key
        guard case .success(let context) = LDContextBuilder(key: resolved).build() else {
            return resolved
        }
        LDClient.get()?.identify(context: context) { _ in }
        publishStatus()
        return resolved
    }

    private func publishStatus() {
        guard let fastHook, let slowHook else { return }
        let text = String(format: "Evaluations requested: %d\n%@\n%@",
                          evaluationsRequested,
                          fastHook.status(),
                          slowHook.status())
        DispatchQueue.main.async { [statusHandler] in
            statusHandler?(text)
        }
    }
}
