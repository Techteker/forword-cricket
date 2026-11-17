import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'services/appwrite_service.dart';

const ink = Color(0xFF090B10);
const panel = Color(0xFF141923);
const red = Color(0xFFF2263D);
const gold = Color(0xFFFFC857);
const muted = Color(0xFF9BA5B5);

class ForwordCricketApp extends StatelessWidget {
  const ForwordCricketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Forword Cricket',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: ink,
        colorScheme: const ColorScheme.dark(
          primary: red,
          secondary: gold,
          surface: panel,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: ink,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          color: panel,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color(0xFF252D3A)),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class AppSignInButton extends StatelessWidget {
  const AppSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () async {
        try {
          await AppwriteService.instance.signInWithGoogle();
        } catch (error) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString())),
          );
        }
      },
      icon: const Icon(Icons.g_mobiledata, size: 26),
      label: const Text('Continue with Google'),
    );
  }
}
