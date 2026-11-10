# Apokolips Messenger

A private-by-default messaging platform for Android, iOS, and Web.

**Web app target:** https://chat.apokolips.xyz

## Technology
- Flutter and Dart — cross-platform client
- Supabase — authentication, PostgreSQL, realtime messaging, and storage
- Firebase Cloud Messaging — planned push notifications

## Current status
- **Phase 01:** Flutter application shell, Apokolips visual theme, responsive navigation, and safe Supabase client configuration.
- **Phase 02:** Passwordless email/SMS OTP authentication, sign-out, and private user profile foundation.
- **Next:** Conversation and realtime messaging foundation.

## Run locally
Install the Flutter SDK, then run:

    flutter pub get
    flutter run

Connect the Supabase project using its URL and public publishable/anon key:

    flutter run --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co --dart-define=SUPABASE_ANON_KEY=YOUR_PUBLIC_KEY

Before testing authentication:
1. Enable Email and Phone providers in Supabase Auth.
2. Configure email OTP templates and an SMS provider.
3. Run `supabase/setup_profiles.sql` in the Supabase SQL Editor.

See [docs/authentication.md](docs/authentication.md) for setup details.

Do not place service-role keys, Firebase service-account credentials, signing keys, or other secrets in the repository or client application.

## Project structure
    lib/
      main.dart
      app.dart
      screens/
        auth_screen.dart
        home_screen.dart
      services/
        auth_service.dart
      theme/
        app_theme.dart
    supabase/
      setup_profiles.sql
    docs/
      architecture.md
      authentication.md

See the documentation directory for architecture, security, and setup notes.
