# Appwrite setup

Create an Appwrite project and register each target platform in Console.

## Flutter run configuration

```bash
flutter pub get
flutter run --dart-define=APPWRITE_ENDPOINT=https://YOUR_REGION.cloud.appwrite.io/v1 --dart-define=APPWRITE_PROJECT_ID=YOUR_PROJECT_ID
```

Do not put an Appwrite API key in the Flutter app. The client SDK uses the public endpoint and project ID; user data must be protected by Appwrite permissions and trusted server-side Functions for sensitive operations.

## Authentication
1. In Appwrite Console, add Android, iOS and/or Web platform with the exact application identifier/hostname.
2. Enable Google as an OAuth provider and configure Google OAuth client credentials.
3. Add the Appwrite success and failure callback URLs required by your platform.
4. Test Google login on a real device and verify a session is created.

## Suggested TablesDB tables
Use the database and table IDs from your Appwrite project. Create tables with the following fields:

- `profiles`: userId (varchar, required), displayName (varchar), avatarUrl (text), birthDate (datetime), ageVerified (boolean), createdAt (datetime).
- `matches`: providerMatchId (varchar), teamA (varchar), teamB (varchar), startsAt (datetime), status (varchar), scoreSummary (text).
- `quizzes`: title (varchar), matchId (varchar), status (varchar), startsAt (datetime), questionCount (integer).
- `questions`: quizId (varchar), prompt (text), optionsJson (text), correctOption (integer). Correct answers must never be exposed to clients before submission; serve them from a trusted Function.
- `quiz_attempts`: userId (varchar), quizId (varchar), score (integer), submittedAt (datetime).
- `leaderboard_entries`: quizId (varchar), userId (varchar), displayName (varchar), score (integer), rank (integer).
- `news_articles`: title (varchar), summary (text), imageUrl (text), category (varchar), sourceName (varchar), publishedAt (datetime), url (text).
- `gift_catalog`: title (varchar), description (text), imageUrl (text), stock (integer), active (boolean).
- `gift_winners`: userId (varchar), quizId (varchar), giftId (varchar), status (varchar), deliveryReference (varchar).

## Permissions and safety
- Public read only for published news, active matches, and public quiz metadata.
- Each profile and attempt is readable/writable only by its owner.
- Never let clients write scores, ranks, winner status, stock, or correct answers.
- Validate age eligibility, one-attempt rules, scoring, tie-breaks, anti-abuse and winner selection in trusted Appwrite Functions.
- Physical gifts only; no entry fee, betting, wallet, cash prize or withdrawal feature.
- Publish official contest rules, privacy policy, eligibility, delivery timelines and support contact before launch.

Live score and news APIs, production database IDs, and server-side Functions must be configured separately. The app currently uses local demonstration content until those services are connected.
