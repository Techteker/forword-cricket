import 'package:appwrite/appwrite.dart';

class AppwriteService {
  AppwriteService._();

  static final AppwriteService instance = AppwriteService._();

  static const endpoint = String.fromEnvironment(
    'APPWRITE_ENDPOINT',
    defaultValue: '',
  );
  static const projectId = String.fromEnvironment(
    'APPWRITE_PROJECT_ID',
    defaultValue: '',
  );

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

  Future<void> signInWithGoogle() async {
    if (!isConfigured) {
      throw StateError(
        'Add APPWRITE_ENDPOINT and APPWRITE_PROJECT_ID using --dart-define.',
      );
    }
    await account.createOAuth2Session(provider: OAuthProvider.google);
  }

  Future<void> signOut() async {
    if (isConfigured) {
      await account.deleteSession(sessionId: 'current');
    }
  }
}
