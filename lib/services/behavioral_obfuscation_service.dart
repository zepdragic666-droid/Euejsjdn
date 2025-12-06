
import 'dart:math';

/// A service that provides behavioral obfuscation (Entropy Cloaking).
///
/// This service introduces random micro-delays to make app behavior
/// less predictable for automated analysis tools.
class BehavioralObfuscationService {
  final _random = Random();

  /// Waits for a random, short duration between `minMilliseconds` and `maxMilliseconds`.
  Future<void> introduceRandomDelay({int minMilliseconds = 50, int maxMilliseconds = 200}) async {
    final delay = minMilliseconds + _random.nextInt(maxMilliseconds - minMilliseconds);
    await Future.delayed(Duration(milliseconds: delay));
  }
}
