import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const PastelFinanceApp());
}

class PastelFinanceApp extends StatelessWidget {
  const PastelFinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pastel Finance',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: Color(0xFFFFB6C1),
          secondary: Color(0xFFB0E0E6),
          surface: Colors.white,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.black,
          onError: Colors.white,
          error: Colors.red,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
