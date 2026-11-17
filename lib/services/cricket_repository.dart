import 'dart:convert';

import 'package:appwrite/appwrite.dart';

import 'appwrite_service.dart';

/// Client-side read repository. Privileged operations (quiz scoring, rankings,
/// age approval and winner selection) must be implemented by Appwrite Functions.
class CricketRepository {
  CricketRepository._();

  static final CricketRepository instance = CricketRepository._();

  TablesDB get _tables => TablesDB(AppwriteService.instance.client);
  Functions get _functions => Functions(AppwriteService.instance.client);

  String get _databaseId => AppwriteService.databaseId;

  bool get isConfigured =>
      AppwriteService.instance.isConfigured && _databaseId.isNotEmpty;

  Future<List<Map<String, dynamic>>> _listRows(
    String tableId, {
    List<String> queries = const [],
  }) async {
    if (!isConfigured || tableId.isEmpty) {
      return const [];
    }
    final result = await _tables.listRows(
      databaseId: _databaseId,
      tableId: tableId,
      queries: queries,
    );
    return result.rows
        .map((row) => Map<String, dynamic>.from(row.data))
        .toList(growable: false);
  }

  Future<List<Map<String, dynamic>>> getMatches() =>
      _listRows(AppwriteService.matchesTableId);

  Future<List<Map<String, dynamic>>> getPublishedNews() =>
      _listRows(AppwriteService.newsTableId);

  Future<List<Map<String, dynamic>>> getActiveQuizzes() =>
      _listRows(AppwriteService.quizzesTableId);

  Future<List<Map<String, dynamic>>> getGiftCatalog() =>
      _listRows(AppwriteService.giftsTableId);

  Future<List<Map<String, dynamic>>> getLeaderboard(String quizId) =>
      _listRows(
        AppwriteService.leaderboardTableId,
        queries: [Query.equal('quizId', quizId), Query.orderAsc('rank')],
      );

  Future<List<Map<String, dynamic>>> getMyGiftWinners() async {
    final userId = await AppwriteService.instance.currentUserId();
    if (userId == null) {
      return const [];
    }
    return _listRows(
      AppwriteService.giftWinnersTableId,
      queries: [Query.equal('userId', userId), Query.orderDesc('createdAt')],
    );
  }

  Future<List<Map<String, dynamic>>> getSavedArticles() async {
    final userId = await AppwriteService.instance.currentUserId();
    if (userId == null) {
      return const [];
    }
    return _listRows(
      AppwriteService.savedArticlesTableId,
      queries: [Query.equal('userId', userId), Query.orderDesc('savedAt')],
    );
  }

  Future<void> saveArticle({
    required String articleId,
    required String title,
    required String sourceName,
  }) async {
    final userId = await AppwriteService.instance.currentUserId();
    if (userId == null) {
      throw StateError('Sign in with Google to save articles.');
    }
    if (!isConfigured || AppwriteService.savedArticlesTableId.isEmpty) {
      throw StateError('Saved articles table is not configured.');
    }
    await _tables.createRow(
      databaseId: _databaseId,
      tableId: AppwriteService.savedArticlesTableId,
      rowId: ID.unique(),
      data: {
        'userId': userId,
        'articleId': articleId,
        'title': title,
        'sourceName': sourceName,
        'savedAt': DateTime.now().toUtc().toIso8601String(),
      },
      permissions: [
        Permission.read(Role.user(userId)),
        Permission.delete(Role.user(userId)),
      ],
    );
  }

  Future<bool> verifyAge(DateTime dateOfBirth) async {
    final body = await executeTrustedFunction(
      AppwriteService.ageVerificationFunctionId,
      {'dateOfBirth': dateOfBirth.toIso8601String()},
    );
    final result = jsonDecode(body);
    return result is Map<String, dynamic> && result['eligible'] == true;
  }

  Future<String> submitQuizAttempt({
    required String quizId,
    required List<int> answers,
  }) => executeTrustedFunction(
    AppwriteService.submitQuizFunctionId,
    {'quizId': quizId, 'answers': answers},
  );

  /// Calls a trusted Function. Never calculate official scores or winners on
  /// the device and never send correct answers to the Flutter client.
  Future<String> executeTrustedFunction(
    String functionId,
    Map<String, dynamic> payload,
  ) async {
    if (!isConfigured || functionId.isEmpty) {
      throw StateError('Appwrite database or Function ID is not configured.');
    }
    final execution = await _functions.createExecution(
      functionId: functionId,
      body: jsonEncode(payload),
      xasync: false,
    );
    return execution.responseBody;
  }
}
