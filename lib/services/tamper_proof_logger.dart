
import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Represents a single, immutable entry in the tamper-proof log.
class LogEntry {
  final String previousHash;
  final DateTime timestamp;
  final String message;
  final String currentHash;

  LogEntry({required this.previousHash, required this.message, required this.timestamp}) 
      : currentHash = _calculateHash(timestamp, message, previousHash);

  static String _calculateHash(DateTime timestamp, String message, String previousHash) {
    final input = '$previousHash${timestamp.toIso8601String()}$message';
    final bytes = utf8.encode(input);
    return sha256.convert(bytes).toString();
  }

  @override
  String toString() {
    return '[LogEntry | ${timestamp.toIso8601String()}]\n  Previous Hash: $previousHash\n  Message: $message\n  Current Hash:  $currentHash';
  }
}

/// A service that creates a tamper-proof, hash-chained audit log.
/// Each log entry is cryptographically linked to the one before it, like a blockchain.
class TamperProofLogger {
  final List<LogEntry> _logChain = [];

  List<LogEntry> get logChain => List.unmodifiable(_logChain);

  TamperProofLogger() {
    // Create the genesis block (the first log entry)
    final genesisEntry = LogEntry(previousHash: '0', message: 'Log Initialized.', timestamp: DateTime.now());
    _logChain.add(genesisEntry);
  }

  /// Adds a new message to the log chain.
  void log(String message) {
    final lastHash = _logChain.last.currentHash;
    final newEntry = LogEntry(previousHash: lastHash, message: message, timestamp: DateTime.now());
    _logChain.add(newEntry);
  }

  /// Verifies the integrity of the entire log chain.
  /// Returns `true` if the chain is valid, `false` if any tampering is detected.
  bool verifyChain() {
    for (int i = 1; i < _logChain.length; i++) {
      final currentEntry = _logChain[i];
      final previousEntry = _logChain[i - 1];

      // Recalculate the hash of the current entry and see if it still matches
      final recalculatedHash = LogEntry._calculateHash(
        currentEntry.timestamp,
        currentEntry.message,
        currentEntry.previousHash
      );
      
      if (currentEntry.currentHash != recalculatedHash) {
        return false; // Hash mismatch, tampering detected!
      }

      // Check if the current entry correctly links to the previous one
      if (currentEntry.previousHash != previousEntry.currentHash) {
        return false; // Chain is broken, tampering detected!
      }
    }
    return true; // Chain is valid
  }

  List<String> getRecentLogs(int count) {
    final logCount = _logChain.length;
    if (count > logCount) {
      count = logCount;
    }
    return _logChain.sublist(logCount - count).map((entry) => entry.toString()).toList();
  }
}
