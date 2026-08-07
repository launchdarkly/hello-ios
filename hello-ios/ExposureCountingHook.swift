import Foundation
import LaunchDarkly

/// Counts the evaluation series stages it observes, so the example can show what exposure
/// deduplication does. Deduplication is declared on the hook via `evaluationExposureDeduper`,
/// the same way a customer would configure any other hook.
///
/// Deduplication skips the whole series, so both counts stay equal and both stop climbing while
/// repeated evaluations resolve to the same result.
final class ExposureCountingHook: Hook {
    private let label: String
    private let window: TimeInterval
    private let onStage: () -> Void
    private let befores = Counter()
    private let afters = Counter()

    /// The per-hook policy. Declaring it here is the Swift equivalent of Android's
    /// `new MetricsHook().evaluationExposureDeduper(window)`.
    let evaluationExposureDeduper: EvaluationExposureDeduper?

    init(label: String, window: TimeInterval, onStage: @escaping () -> Void) {
        self.label = label
        self.window = window
        self.onStage = onStage
        self.evaluationExposureDeduper = EvaluationExposureDeduper(window: window)
    }

    func metadata() -> Metadata {
        Metadata(name: label)
    }

    func beforeEvaluation(seriesContext: EvaluationSeriesContext, seriesData: EvaluationSeriesData) -> EvaluationSeriesData {
        befores.increment()
        onStage()
        return seriesData
    }

    func afterEvaluation(seriesContext: EvaluationSeriesContext, seriesData: EvaluationSeriesData, evaluationDetail: LDEvaluationDetail<LDValue>) -> EvaluationSeriesData {
        afters.increment()
        onStage()
        return seriesData
    }

    /// A line describing this hook's window and how many evaluations have reached it.
    func status() -> String {
        String(format: "%@ (%.0f s): %d (before %d / after %d)",
               label,
               window,
               afters.value,
               befores.value,
               afters.value)
    }
}

/// Tiny thread-safe counter for hook stages invoked from any queue.
private final class Counter {
    private let lock = NSLock()
    private var _value = 0

    var value: Int {
        lock.lock()
        defer { lock.unlock() }
        return _value
    }

    func increment() {
        lock.lock()
        _value += 1
        lock.unlock()
    }
}
