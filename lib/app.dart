import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

class ApokolipsMessengerApp extends StatelessWidget {
  const ApokolipsMessengerApp({super.key, required this.supabaseConfigured});

  final bool supabaseConfigured;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Apokolips Messenger',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.dark,
    home: supabaseConfigured
        ? StreamBuilder<AuthState>(
            stream: Supabase.instance.client.auth.onAuthStateChange,
            builder: (context, snapshot) {
              final session = snapshot.data?.session ??
                  Supabase.instance.client.auth.currentSession;
              return session == null ? const AuthScreen() : const HomeScreen();
            },
          )
        : const _BackendSetupScreen(),
  );
}

class _BackendSetupScreen extends StatelessWidget {
  const _BackendSetupScreen();

  @override
  Widget build(BuildContext context) => const Scaffold(
    body: Center(
      child: Padding(
        padding: EdgeInsets.all(28),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 440),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.bolt, color: AppTheme.cyan, size: 48),
              SizedBox(height: 18),
              Text('Connect your backend', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
              SizedBox(height: 10),
              Text(
                'Add the Supabase project URL and public publishable key using the SUPABASE_URL and SUPABASE_ANON_KEY dart-defines. No private service key is required in the app.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.secondaryText, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
