import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:securitysystem/quantum_protection_screen.dart';
import 'package:securitysystem/services/behavioral_anomaly_service.dart';
import 'package:securitysystem/services/behavioral_obfuscation_service.dart';
import 'package:securitysystem/services/multimodal_ai_defense_service.dart';
import 'package:securitysystem/services/process_cloaking_service.dart';
import 'package:securitysystem/services/rasp_service.dart';
import 'package:securitysystem/services/secure_api_gateway_service.dart';
import 'package:securitysystem/services/secure_http_client.dart';
import 'package:securitysystem/services/secure_storage_service.dart';
import 'package:securitysystem/services/session_service.dart';
import 'package:securitysystem/services/signature_verification_service.dart';
import 'package:securitysystem/services/tamper_proof_logger.dart';

void main() {
  // Instantiate all real and conceptual security services
  final raspService = RaspService();
  final tamperProofLogger = TamperProofLogger();
  final secureHttpClient = SecureHttpClient(http.Client());
  final secureStorageService = SecureStorageService();
  final behavioralObfuscationService = BehavioralObfuscationService();
  final signatureVerificationService = SignatureVerificationService();
  final behavioralAnomalyService = BehavioralAnomalyService();
  final secureApiGatewayService = SecureApiGatewayService();
  final sessionService = SessionService();
  final processCloakingService = ProcessCloakingService();
  final multimodalAiDefenseService = MultimodalAiDefenseService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        // Provide all security services to the entire app
        Provider.value(value: raspService),
        Provider.value(value: tamperProofLogger),
        Provider.value(value: secureHttpClient),
        Provider.value(value: secureStorageService),
        Provider.value(value: behavioralObfuscationService),
        Provider.value(value: signatureVerificationService),
        Provider.value(value: behavioralAnomalyService),
        Provider.value(value: secureApiGatewayService),
        Provider.value(value: sessionService),
        Provider.value(value: processCloakingService),
        Provider.value(value: multimodalAiDefenseService),
      ],
      child: const SecuritySystemApp(),
    ),
  );
}

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark; // Default to dark mode

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}

class SecuritySystemApp extends StatelessWidget {
  const SecuritySystemApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primarySeedColor = Color(0xFF00FFFF); // Neon Cyan/Aqua
    const Color backgroundColor = Color(0xFF0D0D1A); // Deep, near-black purple/blue
    const Color sentientPurple = Color(0xFF9e00ff); // Ethereal Purple Accent

    // Define a common TextTheme using Orbitron for headings
    final TextTheme appTextTheme = TextTheme(
      displayLarge: GoogleFonts.orbitron(fontSize: 57, fontWeight: FontWeight.bold, color: primarySeedColor),
      titleLarge: GoogleFonts.orbitron(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.white),
      bodyMedium: GoogleFonts.openSans(fontSize: 14, color: Colors.white70),
      labelLarge: GoogleFonts.orbitron(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
    );

    // Dark Theme - The Cyber Core
    final ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primarySeedColor,
        brightness: Brightness.dark,
        surface: backgroundColor,
        primary: primarySeedColor,
        secondary: sentientPurple, // The new Sentient accent color
      ),
      textTheme: appTextTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.orbitron(fontSize: 24, fontWeight: FontWeight.bold, color: primarySeedColor),
        iconTheme: const IconThemeData(color: primarySeedColor),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1A1A2E), // Slightly lighter dark blue
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: primarySeedColor.withAlpha(77)),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
                return sentientPurple;
            }
            return Colors.grey;
        }),
        trackColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
                return sentientPurple.withAlpha(128);
            }
            return Colors.grey.withAlpha(128);
        }),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: sentientPurple,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.orbitron(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
       listTileTheme: const ListTileThemeData(
        iconColor: primarySeedColor,
      ),
       dialogTheme: DialogThemeData(
        backgroundColor: const Color(0xFF1A1A2E),
        titleTextStyle: GoogleFonts.orbitron(fontSize: 20, color: sentientPurple),
        contentTextStyle: GoogleFonts.openSans(fontSize: 14, color: Colors.white70),
      ),
    );

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'SecuritySystem',
          theme: darkTheme,
          darkTheme: darkTheme,
          themeMode: themeProvider.themeMode,
          home: const QuantumProtectionScreen(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
