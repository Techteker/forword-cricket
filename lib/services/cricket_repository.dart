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
    if (!isConfigured || tableId.isEmpty) return const [];
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
      async: false,
    );
    return execution.responseBody;
  }
}
