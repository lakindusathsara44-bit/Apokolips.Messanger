import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  final supabaseConfigured = supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  // Only the public client key belongs in a Flutter application.
  if (supabaseConfigured) {
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  }
  runApp(ApokolipsMessengerApp(supabaseConfigured: supabaseConfigured));
}
