import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../apis/auth_api.dart';
import '../../../core/utils.dart';
import '../../pets/view/pets_view.dart';
import '../view/auth_otp_view.dart';
import '../view/auth_phone_view.dart';
import '../view/update_user_profile_view.dart';

class AuthControllerNotifier extends StateNotifier<bool> {
  final AuthApi _authApi;
  AuthControllerNotifier({required AuthApi authApi})
      : _authApi = authApi,
        super(false);

  void createSession({
    required BuildContext context,
    required String phone,
  }) async {
    state = true;
    final result = await _authApi.createSession(
        userId: phone.split('+').last, phone: phone);

    result.fold(
      (l) {
        state = false;
        showSnackbar(context, l.message);
      },
      (r) {
        state = false;
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AuthOtpView(
            userId: r.userId,
          ),
        ));
      },
    );
  }

  void updateSession({
    required BuildContext context,
    required String userId,
    required String secret,
  }) async {
    state = true;
    final result = await _authApi.updateSession(userId: userId, secret: secret);

    result.fold(
      (l) {
        state = false;
        showSnackbar(context, l.message);
      },
      (r) {
        state = false;
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => UpdateUserProfileView(userId: userId),
        ));
      },
    );
  }

  Future<User?> getCurrentAccount() async {
    return await _authApi.getCurrentAccount();
  }

  void logout(BuildContext context) async {
    final result = await _authApi.logout();
    result.fold(
      (l) => null,
      (r) => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const AuthPhoneView(),
          ),
          (route) => false),
    );
  }

  Future<void> createOrUpdateUser(
    WidgetRef ref,
    BuildContext context,
    String userId,
    String name,
    String city,
    String country,
    double lat,
    double lon,
  ) async {
    state = true;
    final result = await _authApi.createOrUpdateUser(
      userId: userId,
      name: name,
      city: city,
      country: country,
      lat: lat,
      lon: lon,
    );

    result.fold(
      (l) {
        state = false;
        showSnackbar(context, l.message);
      },
      (r) {
        state = false;
        // ref
        //     .read(userProfileControllerProvider.notifier)
        //     .getUserProfileDetails(r.$id);
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const PetsView(),
          ),
          (route) => false,
        );
      },
    );
  }

  // Future<UserModel> getUserDetails(String uid) async {
  //   final document = await _userApi.getUserDetails(uid);
  //   final user = UserModel.fromMap(document.data);
  //   return user;
  // }
}
// -----------------------------------------------------------------------------

final authControllerProvider =
    StateNotifierProvider<AuthControllerNotifier, bool>((ref) {
  final authApi = ref.watch(authApiProvider);
  return AuthControllerNotifier(authApi: authApi);
});

final getCurrentAccountProvider = FutureProvider((ref) async {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getCurrentAccount();
});
