import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pet_base/constants/appwrite_constants.dart';

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
  // final Databases _databases;
  // final Storage _storage;
  AuthApi({
    required Account account,
    // required Databases databases,
    // required Storage storage,
  }) : _account = account
  // _databases = databases,
  // _storage = storage
  ;

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
  // final databases = ref.watch(appwriteDatabaseProvider);
  // final storage = ref.watch(appwriteStorageProvider);
  return AuthApi(
    account: account,
    // databases: databases,
    // storage: storage,
  );
});
