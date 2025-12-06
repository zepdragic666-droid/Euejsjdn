
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'quantum_protection_screen.dart';
import 'services/behavioral_anomaly_service.dart';
import 'services/behavioral_obfuscation_service.dart';
import 'services/multimodal_ai_defense_service.dart';
import 'services/process_cloaking_service.dart';
import 'services/rasp_service.dart';
import 'services/secure_api_gateway_service.dart';
import 'services/secure_http_client.dart';
import 'services/secure_storage_service.dart';
import 'services/session_service.dart';
import 'services/signature_verification_service.dart';
import 'services/tamper_proof_logger.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        Provider(create: (_) => RaspService()), // Corrected: Lowercase 's'
        Provider(create: (_) => SessionService()),
        Provider(create: (_) => SecureApiGatewayService()),
        Provider(create: (_) => BehavioralAnomalyService()),
        Provider(create: (_) => MultimodalAiDefenseService()),
        Provider(create: (_) => ProcessCloakingService()),
        Provider(create: (_) => SignatureVerificationService()),
        Provider(create: (_) => TamperProofLogger()),
        Provider(create: (_) => SecureStorageService()),
        Provider(create: (_) => BehavioralObfuscationService()),
        // Corrected: Provide a real http.Client to SecureHttpClient
        Provider(create: (_) => http.Client()),
        ProxyProvider<http.Client, SecureHttpClient>(
          update: (_, client, __) => SecureHttpClient(client),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme appTextTheme = TextTheme(
      displayLarge: GoogleFonts.orbitron(
          fontSize: 36, fontWeight: FontWeight.bold, color: const Color(0xFF00FFFF)),
      titleLarge: GoogleFonts.orbitron(
          fontSize: 24, fontWeight: FontWeight.w500, color: Colors.white),
      bodyMedium: GoogleFonts.openSans(
          fontSize: 14, color: Colors.white.withOpacity(0.8)),
      labelMedium: GoogleFonts.openSans(fontSize: 12, color: Colors.grey),
    );

    final ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF0D0D1A),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF00FFFF), // Neon Cyan/Aqua
        secondary: Color(0xFF9e00ff), // Ethereal Purple
        background: Color(0xFF0D0D1A),
        surface: Color(0xFF1A1A2E),
        onPrimary: Colors.black,
        onSecondary: Colors.white,
        onBackground: Colors.white,
        onSurface: Colors.white,
      ),
      textTheme: appTextTheme,
      // Corrected: Use CardThemeData
      cardTheme: CardThemeData(
        color: const Color(0xFF1A1A2E),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: const Color(0xFF00FFFF).withOpacity(0.3)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: const Color(0xFF00FFFF),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          textStyle: GoogleFonts.orbitron(
              fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Quantum Guard',
          theme: darkTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.dark,
          home: const QuantumProtectionScreen(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
