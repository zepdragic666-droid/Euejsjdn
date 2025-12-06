import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:securitysystem/services/behavioral_anomaly_service.dart';
import 'package:securitysystem/services/multimodal_ai_defense_service.dart';
import 'package:securitysystem/services/process_cloaking_service.dart';
import 'package:securitysystem/services/rasp_service.dart';
import 'package:securitysystem/services/secure_api_gateway_service.dart';
import 'package:securitysystem/services/session_service.dart';

class QuantumProtectionScreen extends StatefulWidget {
  const QuantumProtectionScreen({super.key});

  @override
  State<QuantumProtectionScreen> createState() => _QuantumProtectionScreenState();
}

class _QuantumProtectionScreenState extends State<QuantumProtectionScreen> with TickerProviderStateMixin {
  bool _isSystemArmed = false;
  String _statusMessage = "System is Disarmed";
  String _threatLevel = "None";
  final List<String> _logs = [];

  late final AnimationController _glowingController;
  late final Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _glowingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _glowingController, curve: Curves.easeInOut),
    );

    _addLog("Quantum Shield Initialized.");
  }

  @override
  void dispose() {
    _glowingController.dispose();
    super.dispose();
  }

  void _addLog(String message) {
    setState(() {
      _logs.insert(0, "[${DateTime.now().toIso8601String()}] $message");
      if (_logs.length > 20) {
        _logs.removeLast();
      }
    });
  }

  Future<void> _toggleSystemArm() async {
    final raspService = Provider.of<RaspService>(context, listen: false);
    final behavioralAnomalyService = Provider.of<BehavioralAnomalyService>(context, listen: false);
    final multimodalAiService = Provider.of<MultimodalAiDefenseService>(context, listen: false);
    final processCloakingService = Provider.of<ProcessCloakingService>(context, listen: false);
    final secureApiGatewayService = Provider.of<SecureApiGatewayService>(context, listen: false);
    final sessionService = Provider.of<SessionService>(context, listen: false);

    setState(() {
      _isSystemArmed = !_isSystemArmed;
    });

    if (_isSystemArmed) {
      _addLog("ARMING PROTOCOL INITIATED...");
      _statusMessage = "System is Arming...";

      // --- RASP Checks ---
      _addLog("Running Runtime Application Self-Protection checks...");
      final isCompromised = await raspService.isDeviceCompromised();
      if (isCompromised) {
        _triggerAlarm("DEVICE COMPROMISED! Root/Jailbreak detected.");
        return;
      }
      final isDebuggerAttached = await raspService.isDebuggerAttached();
      if (isDebuggerAttached) {
        _triggerAlarm("INTRUSION! Debugger attached.");
        return;
      }
      _addLog("RASP checks passed. Device integrity confirmed.");

      // --- Session & API Gateway ---
      _addLog("Establishing secure session...");
      final sessionId = await sessionService.startSession();
      _addLog("Session `$sessionId` started.");

      _addLog("Authenticating with Secure API Gateway...");
      final apiToken = await secureApiGatewayService.authenticate();
      if (apiToken == null) {
        _triggerAlarm("CRITICAL: API Gateway Authentication Failed!");
        return;
      }
      _addLog("API Gateway token acquired.");

      // --- Behavioral & AI Monitoring ---
      _addLog("Activating behavioral anomaly detection...");
      behavioralAnomalyService.startMonitoring((anomaly) {
        _addLog("ALERT: Behavioral anomaly detected: $anomaly");
        setState(() {
          _threatLevel = "High";
        });
        _triggerAlarm("Unusual user behavior detected! Threat level escalated.");
      });

      _addLog("Engaging Multimodal AI Defense Matrix...");
      multimodalAiService.startMonitoring();

      _addLog("Initiating Process Cloaking...");
      processCloakingService.startCloaking();

      setState(() {
        _statusMessage = "Quantum Shield: ARMED";
        _threatLevel = "Low";
      });
      _addLog("SYSTEM ARMED. All shields are operational.");

    } else {
      _disarmSystem();
    }
  }

  void _disarmSystem() {
    _addLog("DISARMING asecuritysystem...");
    Provider.of<BehavioralAnomalyService>(context, listen: false).stopMonitoring();
    Provider.of<MultimodalAiDefenseService>(context, listen: false).stopMonitoring();
    Provider.of<ProcessCloakingService>(context, listen: false).stopCloaking();
    Provider.of<SessionService>(context, listen: false).endSession();

    setState(() {
      _isSystemArmed = false;
      _statusMessage = "System is Disarmed";
      _threatLevel = "None";
    });
    _addLog("SYSTEM DISARMED. Shields are down.");
  }

  void _triggerAlarm(String reason) {
    _addLog("ALARM TRIGGERED: $reason");
    setState(() {
      _statusMessage = "SECURITY BREACH!";
      _threatLevel = "CRITICAL";
      _isSystemArmed = false; // Disarm on breach
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 30),
            SizedBox(width: 10),
            Text("SECURITY ALERT"),
          ],
        ),
        content: Text(
          reason,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _disarmSystem(); 
            },
            child: const Text("Acknowledge & Disarm"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color accentColor = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quantum Guard'),
        leading: const Icon(Icons.shield_outlined, size: 28),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // --- Arming Button --- 
              _buildArmingButton(primaryColor),
              const SizedBox(height: 30),
              
              // --- Status and Logs --- 
              _buildStatusSection(accentColor),
              const SizedBox(height: 20),
              _buildLogSection(accentColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArmingButton(Color primaryColor) {
    return GestureDetector(
      onTap: _toggleSystemArm,
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          return Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _isSystemArmed ? Colors.grey[900] : const Color(0xFF1A1A2E),
              border: Border.all(color: _isSystemArmed ? primaryColor : Colors.grey[600]!, width: 4),
              boxShadow: _isSystemArmed ? [
                BoxShadow(
                  color: primaryColor.withOpacity(0.7 * _glowAnimation.value),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.8 * _glowAnimation.value),
                  blurRadius: 60,
                  spreadRadius: 10,
                )
              ] : [],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isSystemArmed ? Icons.gpp_good_rounded : Icons.gpp_bad_rounded,
                    size: 80,
                    color: _isSystemArmed ? primaryColor : Colors.grey[600],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _isSystemArmed ? "ARMED" : "DISARMED",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: _isSystemArmed ? primaryColor : Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }


  Widget _buildStatusSection(Color accentColor) {
    Color threatColor;
    switch (_threatLevel) {
      case "High":
        threatColor = Colors.orange;
        break;
      case "CRITICAL":
        threatColor = Colors.red;
        break;
      case "Low":
        threatColor = Colors.green;
        break;
      default:
        threatColor = Colors.grey;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "System Status",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: accentColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatusChip("Status", _statusMessage, _isSystemArmed ? Colors.green : Colors.grey),
                _buildStatusChip("Threat Level", _threatLevel, threatColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white70)),
        const SizedBox(height: 5),
        Chip(
          label: Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: color.withOpacity(0.3),
          side: BorderSide(color: color),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        ),
      ],
    );
  }


  Widget _buildLogSection(Color accentColor) {
    return Card(
      child: SizedBox(
        height: 250,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Security Log",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(color: accentColor),
              ),
              const Divider(height: 20),
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  itemCount: _logs.length,
                  itemBuilder: (context, index) {
                    final log = _logs[index];
                    Color logColor = Colors.white70;
                    if (log.contains("ALARM") || log.contains("CRITICAL")) {
                      logColor = Colors.red;
                    } else if (log.contains("ALERT") || log.contains("anomaly")) {
                      logColor = Colors.orange;
                    } else if (log.contains("ARMED")) {
                      logColor = Colors.green;
                    }

                    return Text(
                      log,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: logColor),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
