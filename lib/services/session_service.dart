
import 'dart:async';
import 'dart:math';

// A conceptual service to manage user sessions with enhanced security.
class SessionService {
  String? _sessionId;
  Timer? _sessionTimeout;

  // Starts a new session and returns a unique session ID.
  Future<String> startSession() async {
    _sessionId = _generateSessionId();
    print('SESSION: New session started: $_sessionId');
    _resetSessionTimeout();
    return _sessionId!;
  }

  // Ends the current session.
  void endSession() {
    print('SESSION: Session ended: $_sessionId');
    _sessionId = null;
    _sessionTimeout?.cancel();
  }

  // Resets the session timeout.
  void _resetSessionTimeout() {
    _sessionTimeout?.cancel();
    _sessionTimeout = Timer(const Duration(minutes: 5), () {
      print('SESSION: Session timed out due to inactivity.');
      endSession();
    });
  }

  // Generates a unique session ID.
  String _generateSessionId() {
    final random = Random.secure();
    final values = List<int>.generate(16, (i) => random.nextInt(256));
    return values.map((v) => v.toRadixString(16).padLeft(2, '0')).join();
  }
}
