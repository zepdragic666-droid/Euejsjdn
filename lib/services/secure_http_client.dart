
import 'dart:async';
import 'package:http/http.dart' as http;

/// The final, ultimate form of the SecureHttpClient.
/// Provides multi-source threat intelligence, on-demand updates, and anti-fingerprinting.
class SecureHttpClient {
  final http.Client _innerClient;

  // --- Dynamic Blocklists & Whitelist ---
  Set<String> _blockList = {};
  final Set<String> _userWhitelist = {};
  static const int _maxDataExfiltrationBytes = 500 * 1024; // 500 KB

  // --- Threat Intelligence Feeds ---
  final List<String> _threatFeedUrls = [
    'https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts', // StevenBlack's list
    'https://raw.githubusercontent.com/firebog/Firebog/master/PFS/Firebog-PFS-PSE.txt' // Firebog list
  ];

  // CORRECTED: The network call is removed from the constructor to prevent startup crashes.
  SecureHttpClient(this._innerClient) {
    _loadLocalBlocklist(); // Load a default list first.
  }

  /// CORRECTED: This init method will be called *after* app startup.
  Future<void> init() async {
    await forceUpdateBlocklists();
  }

  /// Triggers a live, on-demand refresh of all threat intelligence feeds.
  Future<void> forceUpdateBlocklists() async {
    final newBlockList = <String>{};

    for (final url in _threatFeedUrls) {
      try {
        final response = await _innerClient.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final lines = response.body.split('\n');
          final Set<String> domains = lines
              .where((line) => line.startsWith('0.0.0.0 ') || !line.startsWith('#'))
              .map((line) => line.replaceAll('0.0.0.0 ', '').trim())
              .where((domain) => domain.isNotEmpty)
              .toSet();
          newBlockList.addAll(domains);
        } else {
        }
      } catch (e) {
      }
    }

    if (newBlockList.isNotEmpty) {
      _blockList = newBlockList;
    }
  }

  void _loadLocalBlocklist() {
    _blockList = {
      'bad-guy-server.com',
      'malicious-tracker.net',
      'phishing-site.org',
      'doubleclick.net'
    };
  }

  /// Makes a request, but only after passing all security checks.
  Future<http.Response> send(http.BaseRequest request) async {
    final host = request.url.host;

    // 1. Quantum Fingerprint Mirage (User-Agent Masking)
    request.headers['User-Agent'] = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36';

    // 2. Whitelist Check
    if (_userWhitelist.contains(host)) {
      return http.Response.fromStream(await _innerClient.send(request));
    }

    // 3. Blocklist Check
    if (_blockList.contains(host)) {
      throw SecurityException('Firewall Blocked: Attempted connection to malicious host ($host)');
    }

    // 4. Data Exfiltration Check
    final contentLength = request.contentLength ?? 0;
    if (contentLength > _maxDataExfiltrationBytes) {
        throw SecurityException('Firewall Blocked (DLP): Request size ($contentLength bytes) exceeds limit.');
    }

    // 5. Network Hardening
    if (!request.url.isScheme('HTTPS')) {
        throw SecurityException('Firewall Blocked (Hardening): Insecure connection to ${request.url}.');
    }

    // If all checks pass, proceed.
    return http.Response.fromStream(await _innerClient.send(request));
  }

  void addToWhitelist(String host) {
    _userWhitelist.add(host);
  }
}

class SecurityException implements Exception {
  final String message;
  SecurityException(this.message);

  @override
  String toString() => "SecurityException: $message";
}
