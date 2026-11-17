# Forword Cricket

A Flutter cricket knowledge and quiz app with cricket news, live scores, leaderboards and physical-gift rewards.

## Product rules
- Free entry; no betting, deposits, wallet, cash prizes or cash withdrawals.
- Google sign-in only.
- 16+ age gate before quiz participation.
- Physical gifts for verified winners, subject to published rules and eligibility.

## Stack
- Flutter / Dart
- Appwrite Authentication, TablesDB and Storage
- Google OAuth through Appwrite

## Getting started
1. Install Flutter stable (Dart 3.10+ recommended).
2. Generate platform runners once: `flutter create --platforms=android,ios,web . --project-name forword_cricket`.
3. Run `flutter pub get`.
4. Run `flutter run --dart-define=APPWRITE_ENDPOINT=https://YOUR_REGION.cloud.appwrite.io/v1 --dart-define=APPWRITE_PROJECT_ID=YOUR_PROJECT_ID`.
5. Register Android/iOS/Web platforms in Appwrite and enable Google OAuth.
6. Configure the callback URL and OAuth provider credentials in Appwrite Console.

See `docs/APPWRITE_SETUP.md` for database tables and permissions. Never put an Appwrite API key in a Flutter client.

## Current build scope
This first implementation provides a premium responsive app shell, navigation, sample cricket content, quiz flow, result/leaderboard/rewards/news/profile screens, Appwrite client configuration and Google OAuth entry point. Live score/news feeds and production reward issuance require real provider credentials and backend configuration.
