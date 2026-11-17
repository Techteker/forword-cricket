# Appwrite setup

Create an Appwrite project and register each target platform in Console.

## Flutter run configuration

```bash
flutter pub get
flutter run \
  --dart-define=APPWRITE_ENDPOINT=https://YOUR_REGION.cloud.appwrite.io/v1 \
  --dart-define=APPWRITE_PROJECT_ID=YOUR_PROJECT_ID \
  --dart-define=APPWRITE_DATABASE_ID=YOUR_DATABASE_ID \
  --dart-define=APPWRITE_AGE_VERIFY_FUNCTION_ID=age-verify \
  --dart-define=APPWRITE_SUBMIT_QUIZ_FUNCTION_ID=submit-quiz
```

Do not put an Appwrite API key in the Flutter app. The client SDK uses the public endpoint and project ID; user data must be protected by Appwrite permissions and trusted server-side Functions for sensitive operations.

## Authentication
1. In Appwrite Console, add Android, iOS and/or Web platform with the exact application identifier/hostname.
2. Enable Google as an OAuth provider and configure Google OAuth client credentials.
3. Add the Appwrite success and failure callback URLs required by your platform.
4. For Flutter Web, deploy the included `web/auth.html` file at the same app origin and register the exact production hostname in Appwrite. The app sends web OAuth success/failure callbacks to `/auth.html`.
5. Test Google login on a real device and verify a session is created.

## Suggested TablesDB tables
Use the database and table IDs from your Appwrite project. Create the tables and attributes before enabling the matching feature.

- `profiles`: userId (varchar, required), displayName (varchar), avatarUrl (text), birthDate (datetime, private), ageVerified (boolean), createdAt (datetime).
- `matches`: providerMatchId (varchar), teamA (varchar), teamB (varchar), startsAt (datetime), status (varchar), scoreSummary (text).
- `quizzes`: title (varchar), matchId (varchar), status (varchar), startsAt (datetime), questionCount (integer).
- `questions`: quizId (varchar), prompt (text), optionsJson (text), correctOption (integer). Correct answers must never be exposed to clients before submission; serve them from a trusted Function.
- `quiz_attempts`: userId (varchar), quizId (varchar), score (integer), submittedAt (datetime).
- `leaderboard_entries`: quizId (varchar), userId (varchar), displayName (varchar), score (integer), rank (integer).
- `news_articles`: title (varchar), summary (text), imageUrl (text), category (varchar), sourceName (varchar), publishedAt (datetime), url (text), status (varchar; use `draft`, `review`, or `published`).
- `gift_catalog`: title (varchar), description (text), imageUrl (text), stock (integer), active (boolean).
- `gift_winners`: userId (varchar), quizId (varchar), giftId (varchar), status (varchar), deliveryReference (varchar), createdAt (datetime).
- `saved_articles`: userId (varchar), articleId (varchar), title (varchar), sourceName (varchar), savedAt (datetime).

Create indexes for fields used in queries: `news_articles.status`; `gift_catalog.active`; `leaderboard_entries.quizId` and `leaderboard_entries.rank`; `saved_articles.userId`, `saved_articles.articleId`, and `saved_articles.savedAt`; `gift_winners.userId` and `gift_winners.createdAt`.

## Permissions and safety
- Public read only for published news, active matches, and public quiz metadata.
- Each profile, bookmark and attempt is readable/writable only by its owner.
- Never let clients write scores, ranks, winner status, stock, or correct answers.
- Validate age eligibility, one-attempt rules, scoring, tie-breaks, anti-abuse and winner selection in trusted Appwrite Functions.
- Physical gifts only; no entry fee, betting, wallet, cash prize or withdrawal feature.
- Publish official contest rules, privacy policy, eligibility, delivery timelines and support contact before launch.

## Flutter environment variables

| Define | Purpose |
|---|---|
| `APPWRITE_ENDPOINT` | Appwrite API endpoint |
| `APPWRITE_PROJECT_ID` | Appwrite project ID |
| `APPWRITE_DATABASE_ID` | TablesDB database ID |
| `APPWRITE_MATCHES_TABLE_ID` | Matches table (default `matches`) |
| `APPWRITE_NEWS_TABLE_ID` | News table (default `news_articles`) |
| `APPWRITE_QUIZZES_TABLE_ID` | Quizzes table (default `quizzes`) |
| `APPWRITE_GIFTS_TABLE_ID` | Gift catalog table (default `gift_catalog`) |
| `APPWRITE_LEADERBOARD_TABLE_ID` | Leaderboard table (default `leaderboard_entries`) |
| `APPWRITE_SAVED_ARTICLES_TABLE_ID` | Saved articles table (default `saved_articles`) |
| `APPWRITE_GIFT_WINNERS_TABLE_ID` | Winner and delivery status table (default `gift_winners`) |
| `APPWRITE_AGE_VERIFY_FUNCTION_ID` | Trusted Function that checks 16+ eligibility |
| `APPWRITE_SUBMIT_QUIZ_FUNCTION_ID` | Trusted Function that validates answers and stores a quiz attempt |

For web OAuth, Appwrite and the deployed app should use a compatible HTTPS/custom-domain setup so browser cookie restrictions do not block the session. On Android/iOS the SDK uses the `appwrite-callback-<PROJECT_ID>` callback scheme.

The Flutter repository filters news to rows with `status = published` and gift catalogue rows to `active = true`. Configure the corresponding attributes and indexes before testing those screens. If the required schema is absent, the read will fail rather than silently treating draft news or inactive gifts as public.

Add the Appwrite `age-verify` Function to validate the date of birth and persist only the minimum eligibility result. Add the `submit-quiz` Function to authenticate the session, enforce one attempt, load correct answers privately, calculate the score on the server, apply tie-break rules and write the leaderboard. The client must never submit its own score or rank. Function IDs can be customised with the defines above.

The current sample matches, sample quiz questions, article cards and sample leaderboard are demonstration-only. Live match data requires a licensed/approved cricket data provider; news requires an approved RSS/API ingestion pipeline. Physical gift fulfilment needs stock management, winner review and delivery tracking. Configure these services and publish final privacy/contest terms before release.
