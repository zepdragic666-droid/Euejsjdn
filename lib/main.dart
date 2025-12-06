
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cyber_home_screen.dart'; // Import the new screen

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class ThemeProvider with ChangeNotifier {
  // For now, we are locking the theme to dark mode for the cyber aesthetic.
  ThemeMode _themeMode = ThemeMode.dark;
  ThemeMode get themeMode => _themeMode;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the Cyber Theme
    final ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      fontFamily: 'monospace',
      scaffoldBackgroundColor: const Color(0xFF0A0A1A),
      primaryColor: const Color(0xFF00FFFF), // Bright Cyan
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF00FFFF),
        secondary: Color(0xFF00FFFF), // Glow Color
        background: Color(0xFF0A0A1A),
        surface: Color(0xFF1A1A2E),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontFamily: 'monospace', color: Colors.white, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(fontFamily: 'monospace', color: Colors.white70),
        bodyMedium: TextStyle(fontFamily: 'monospace', color: Colors.white60),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: const Color(0xFF00FFFF),
        ),
      ),
    );

    return MaterialApp(
      title: 'Quantum Guard',
      theme: darkTheme, // Use the cyber theme
      darkTheme: darkTheme,
      themeMode: Provider.of<ThemeProvider>(context).themeMode,
      home: const CyberHomeScreen(), // Set the new screen as the home
      debugShowCheckedModeBanner: false,
    );
  }
}


