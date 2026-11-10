import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

class ApokolipsMessengerApp extends StatelessWidget {
  const ApokolipsMessengerApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Apokolips Messenger',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.dark,
    home: const HomeScreen(),
  );
}
