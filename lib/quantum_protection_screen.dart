
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/secure_http_client.dart';

// CORRECTED: Converted to a StatefulWidget to handle initialization.
class QuantumProtectionScreen extends StatefulWidget {
  const QuantumProtectionScreen({super.key});

  @override
  State<QuantumProtectionScreen> createState() =>
      _QuantumProtectionScreenState();
}

class _QuantumProtectionScreenState extends State<QuantumProtectionScreen> {
  @override
  void initState() {
    super.initState();
    // CORRECTED: The network initialization is now called safely after the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Use listen: false because we are in initState.
      Provider.of<SecureHttpClient>(context, listen: false).init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.background,
              const Color(0xFF1A1A2E),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildHeader(theme),
                const SizedBox(height: 40),
                _buildStatusCard(theme),
                const SizedBox(height: 40),
                _buildActionButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      children: [
        Icon(
          Icons.security,
          size: 80,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 20),
        Text(
          'Quantum Guard',
          style: theme.textTheme.displayLarge,
        ),
        const SizedBox(height: 8),
        Text(
          'Your Digital Fortress is Active',
          style: theme.textTheme.titleLarge?.copyWith(color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildStatusCard(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'System Status: Fully Operational',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildStatusRow(theme, Icons.check_circle, 'RASP Active'),
            _buildStatusRow(
                theme, Icons.network_check, 'Firewall Engaged'),
            _buildStatusRow(theme, Icons.bug_report, 'Threat Intel Updated'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(ThemeData theme, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.greenAccent, size: 20),
          const SizedBox(width: 12),
          Text(text, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    return ElevatedButton( // This is the centrally placed button
      onPressed: () {
        // Action for the button
      },
      child: const Text('Perform Security Scan'),
    );
  }
}
