# Apokolips Messenger

A private-by-default messaging platform for Android, iOS, and Web.

## Planned technology

- Flutter and Dart for the cross-platform client
- Supabase for authentication, PostgreSQL, realtime messaging, and storage
- Firebase Cloud Messaging for push notifications

## Project status

Foundation setup is in progress. Authentication, messaging, calls, and end-to-end encryption will be introduced in staged releases.

## Development

Flutter SDK setup and local run instructions will be added with the application foundation.

## Security

Never commit Supabase service-role keys, Firebase service-account files, signing keys, or other secrets. Client applications must use only public client configuration and enforce authorization with database policies.
