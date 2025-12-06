
import 'package:flutter/material.dart';

class CyberHomeScreen extends StatelessWidget {
  const CyberHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final glowColor = theme.colorScheme.secondary;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0A0A1A), Color(0xFF1A1A2E)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(glowColor),
                const SizedBox(height: 40),
                _buildStatusGrid(glowColor),
                const Spacer(),
                _buildActionButton(glowColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Color glowColor) {
    return Text(
      'QUANTUM\nGUARD',
      style: TextStyle(
        fontFamily: 'monospace',
        fontSize: 48,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        height: 1.1,
        shadows: [
          Shadow(blurRadius: 10, color: glowColor),
          Shadow(blurRadius: 20, color: glowColor),
        ],
      ),
    );
  }

  Widget _buildStatusGrid(Color glowColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '> System Status',
          style: TextStyle(
              fontFamily: 'monospace',
              color: Colors.white70,
              fontSize: 16,
              shadows: [Shadow(blurRadius: 5, color: glowColor.withOpacity(0.5))]),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStatusCard('FIREWALL', 'ONLINE', glowColor, Icons.shield),
            _buildStatusCard('THREAT INTEL', 'UPDATING', glowColor, Icons.analytics),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStatusCard('RASP', 'ACTIVE', glowColor, Icons.memory),
            _buildStatusCard('NETWORK', 'SECURE', glowColor, Icons.wifi_protected_setup),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusCard(String title, String status, Color glowColor, IconData icon) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: glowColor.withOpacity(0.5), width: 1),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [glowColor.withOpacity(0.1), Colors.black.withOpacity(0.2)],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, size: 32, color: glowColor),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontFamily: 'monospace', color: Colors.white, fontWeight: FontWeight.bold)),
                Text(status, style: TextStyle(fontFamily: 'monospace', color: glowColor, fontWeight: FontWeight.bold)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(Color glowColor) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: glowColor.withOpacity(0.7),
              blurRadius: 25,
              spreadRadius: -5,
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: glowColor,
            foregroundColor: Colors.black,
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          ),
          onPressed: () {},
          child: const Text(
            'INITIATE DEEP SCAN',
            style: TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
