# Architecture — Phase 01

## Client
Flutter and Dart provide one codebase for Android, iOS, and Web. The UI is separated into app composition, theme, and screens.

## Backend
Supabase is the planned backend for authentication, PostgreSQL, realtime events, and object storage. The client accepts only the project URL and public anon/publishable key through compile-time configuration:

    flutter run --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co --dart-define=SUPABASE_ANON_KEY=YOUR_PUBLIC_KEY

Never use a service-role key in a mobile or web client. Every exposed table must have appropriate Row Level Security policies.

## Planned service boundaries
- Authentication and account profiles
- Conversations, members, messages, and receipts
- Media uploads and access control
- Push notification delivery
- Calling and end-to-end encryption (later phases)

Database objects for this product should be isolated from unrelated applications in the existing Supabase project, preferably with an apm_ prefix or a dedicated schema. No database schema is changed in Phase 01.

## Security principles
- Private by default; deny access unless explicitly granted.
- Validate membership on every conversation read/write.
- Store secrets only in trusted server-side environments.
- Use an audited Signal Protocol implementation for future end-to-end encryption; do not design custom cryptography.
