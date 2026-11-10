# Apokolips Messenger

A private-by-default messaging platform for Android, iOS, and Web.

**Web app target:** https://chat.apokolips.xyz

## Technology
- Flutter and Dart — cross-platform client
- Supabase — authentication, PostgreSQL, realtime messaging, and storage
- Firebase Cloud Messaging — planned push notifications

## Current status
Phase 01 establishes the Flutter application shell, Apokolips visual theme, responsive navigation, and safe Supabase configuration entry point. Authentication and live messaging are planned for later phases.

## Run locally
Install the Flutter SDK, then run:

    flutter pub get
    flutter run

To connect the existing Supabase project, supply its URL and public anon/publishable key at build time:

    flutter run --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co --dart-define=SUPABASE_ANON_KEY=YOUR_PUBLIC_KEY

Do not place service-role keys, Firebase service-account credentials, signing keys, or other secrets in the repository or client application.

## Project structure
    lib/
      main.dart
      app.dart
      screens/
        home_screen.dart
      theme/
        app_theme.dart
    docs/
      architecture.md

See docs/architecture.md for architecture and security notes.
