import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart' as enums;
import 'package:flutter/foundation.dart' show kIsWeb;

class AppwriteService {
  AppwriteService._();

  static final AppwriteService instance = AppwriteService._();

  static const endpoint = String.fromEnvironment('APPWRITE_ENDPOINT', defaultValue: '');
  static const projectId = String.fromEnvironment('APPWRITE_PROJECT_ID', defaultValue: '');
  static const databaseId = String.fromEnvironment('APPWRITE_DATABASE_ID', defaultValue: '');

  static const matchesTableId = String.fromEnvironment('APPWRITE_MATCHES_TABLE_ID', defaultValue: 'matches');
  static const newsTableId = String.fromEnvironment('APPWRITE_NEWS_TABLE_ID', defaultValue: 'news_articles');
  static const quizzesTableId = String.fromEnvironment('APPWRITE_QUIZZES_TABLE_ID', defaultValue: 'quizzes');
  static const giftsTableId = String.fromEnvironment('APPWRITE_GIFTS_TABLE_ID', defaultValue: 'gift_catalog');
  static const leaderboardTableId = String.fromEnvironment('APPWRITE_LEADERBOARD_TABLE_ID', defaultValue: 'leaderboard_entries');
  static const savedArticlesTableId = String.fromEnvironment('APPWRITE_SAVED_ARTICLES_TABLE_ID', defaultValue: 'saved_articles');
  static const submitQuizFunctionId = String.fromEnvironment('APPWRITE_SUBMIT_QUIZ_FUNCTION_ID', defaultValue: '');
  static const ageVerificationFunctionId = String.fromEnvironment('APPWRITE_AGE_VERIFY_FUNCTION_ID', defaultValue: '');

  late final Client client = Client()
    ..setEndpoint(endpoint)
    ..setProject(projectId);

  late final Account account = Account(client);

  bool get isConfigured => endpoint.isNotEmpty && projectId.isNotEmpty;

  Future<bool> hasSession() async {
    if (!isConfigured) return false;
    try {
      await account.get();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<String?> currentUserId() async {
    if (!isConfigured) return null;
    try {
      final user = await account.get();
      return user.$id;
    } catch (_) {
      return null;
    }
  }

  Future<void> signInWithGoogle() async {
    if (!isConfigured) {
      throw StateError('Add APPWRITE_ENDPOINT and APPWRITE_PROJECT_ID using --dart-define.');
    }
    if (kIsWeb) {
      final callback = '${Uri.base.origin}/auth.html';
      await account.createOAuth2Session(
        provider: enums.OAuthProvider.google,
        success: callback,
        failure: callback,
      );
    } else {
      await account.createOAuth2Session(provider: enums.OAuthProvider.google);
    }
  }

  Future<void> signOut() async {
    if (isConfigured) {
      await account.deleteSession(sessionId: 'current');
    }
  }
}
