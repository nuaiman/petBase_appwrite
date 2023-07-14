import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../constants/appwrite_constants.dart';

import '../core/failure.dart';
import '../core/providers.dart';
import '../core/type_defs.dart';

abstract class IAuthApi {
  FutureEither<Token> createSession(
      {required String userId, required String phone});
  FutureEither<Session> updateSession(
      {required String userId, required String secret});
  FutureEither<User> createOrUpdateUser({
    required String userId,
    required String name,
    required String city,
    required String country,
    required double lat,
    required double lon,
    // required List<String> pets,
    // required List<String> likes,
    // required List<String> conversations,
  });
  Future<User?> getCurrentAccount();
  FutureEitherVoid logout();
}
//------------------------------------------------------------------------------

class AuthApi implements IAuthApi {
  final Account _account;
  final Databases _databases;
  AuthApi({
    required Account account,
    required Databases databases,
  })  : _account = account,
        _databases = databases;

  @override
  FutureEither<Token> createSession(
      {required String userId, required String phone}) async {
    try {
      Token token =
          await _account.createPhoneSession(userId: userId, phone: phone);
      return right(token);
    } on AppwriteException catch (e, stackTrace) {
      return left(
          Failure(e.message ?? 'Some unexpected error occured!', stackTrace));
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }

  @override
  FutureEither<Session> updateSession(
      {required String userId, required String secret}) async {
    try {
      Session session =
          await _account.updatePhoneSession(userId: userId, secret: secret);
      return right(session);
    } on AppwriteException catch (e, stackTrace) {
      return left(
          Failure(e.message ?? 'Some unexpected error occured!', stackTrace));
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }

  @override
  Future<User?> getCurrentAccount() async {
    try {
      return await _account.get();
    } on AppwriteException catch (_) {
      return null;
    } catch (_) {
      return null;
    }
  }

  @override
  FutureEitherVoid logout() async {
    try {
      await _account.deleteSession(sessionId: 'current');
      return right(null);
    } on AppwriteException catch (e, stackTrace) {
      return left(
          Failure(e.message ?? 'Some unexpected error occured!', stackTrace));
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }

  @override
  FutureEither<User> createOrUpdateUser({
    required String userId,
    required String name,
    required String city,
    required String country,
    required double lat,
    required double lon,
  }) async {
    try {
      await _account.updateName(name: name);
      User user = await _account.updatePrefs(
        prefs: {
          'userId': userId,
          'name': name,
          'city': city,
          'country': country,
          'lat': lat,
          'lon': lon,
          'imageUrl':
              'https://cloud.appwrite.io/v1/storage/buckets/64a51f3f0f01b2e0dc88/files/64a54272406a94f86556/view?project=${AppwriteConstants.projectId}&mode=admin',
        },
      );
      //++++++++++++++++++++ Update/ Create User in database +++++++++++++++++++
      try {
        await _databases.updateDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.usersCollection,
          documentId: userId,
          data: {
            'id': userId,
            'name': name,
            'imageUrl': user.prefs.data['imageUrl'],
          },
        );
      } on AppwriteException catch (e) {
        if (e.code == 404) {
          await _databases.createDocument(
            databaseId: AppwriteConstants.databaseId,
            collectionId: AppwriteConstants.usersCollection,
            documentId: userId,
            data: {
              'id': userId,
              'name': name,
              'imageUrl': user.prefs.data['imageUrl'],
            },
          );
        }
      } catch (e) {
        rethrow;
      }
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

      return right(user);
    } on AppwriteException catch (e, stackTrace) {
      return left(
          Failure(e.message ?? 'Some unexpected error occured!', stackTrace));
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }
}
//------------------------------------------------------------------------------

final authApiProvider = Provider((ref) {
  final account = ref.watch(appwriteAccountProvider);
  final databases = ref.watch(appwriteDatabaseProvider);
  return AuthApi(
    account: account,
    databases: databases,
  );
});
