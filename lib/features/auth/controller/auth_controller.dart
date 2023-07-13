import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_base/features/loading/loading_controller.dart';
import 'package:pet_base/models/user_model.dart';

import '../../../apis/auth_api.dart';
import '../../../core/utils.dart';
import '../../initialization/view/initialization_view.dart';
import '../../pets/view/pets_view.dart';
import '../view/auth_otp_view.dart';
import '../view/auth_phone_view.dart';
import '../view/update_user_profile_view.dart';

class AuthControllerNotifier extends StateNotifier<UserModel> {
  final AuthApi _authApi;
  final LoadingNotifier _loader;
  AuthControllerNotifier({
    required AuthApi authApi,
    required LoadingNotifier loader,
  })  : _authApi = authApi,
        _loader = loader,
        super(
          UserModel(
            id: '',
            name: '',
            phoneNumber: '',
            city: '',
            country: '',
            imageUrl: '',
            lat: 0.0,
            lon: 0.0,
            pets: [],
            likes: [],
            conversations: [],
          ),
        );

  void createSession({
    required BuildContext context,
    required String phone,
  }) async {
    _loader.changeLoadingStatus(true);
    final result = await _authApi.createSession(
        userId: phone.split('+').last, phone: phone);

    result.fold(
      (l) {
        _loader.changeLoadingStatus(false);
        showSnackbar(context, l.message);
      },
      (r) {
        _loader.changeLoadingStatus(false);
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
    _loader.changeLoadingStatus(true);
    final result = await _authApi.updateSession(userId: userId, secret: secret);

    result.fold(
      (l) {
        _loader.changeLoadingStatus(false);
        showSnackbar(context, l.message);
      },
      (r) {
        _loader.changeLoadingStatus(false);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => UpdateUserProfileView(userId: userId),
        ));
      },
    );
  }

  Future<User?> getCurrentAccount() async {
    User? user = await _authApi.getCurrentAccount();
    if (user != null) {
      state = UserModel(
        id: user.$id,
        name: user.name,
        phoneNumber: user.phone,
        city: user.prefs.data['city'],
        country: user.prefs.data['country'],
        imageUrl: user.prefs.data['imageUrl'],
        lat: user.prefs.data['lat'],
        lon: user.prefs.data['lon'],
        pets: user.prefs.data['pets'] ?? [],
        likes: user.prefs.data['likes'] ?? [],
        conversations: user.prefs.data['conversations'] ?? [],
      );
    }
    return user;
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
    _loader.changeLoadingStatus(true);
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
        _loader.changeLoadingStatus(false);
        showSnackbar(context, l.message);
      },
      (r) {
        state = UserModel(
          id: r.$id,
          name: r.name,
          phoneNumber: r.phone,
          city: r.prefs.data['city'],
          country: r.prefs.data['country'],
          imageUrl: r.prefs.data['imageUrl'],
          lat: r.prefs.data['lat'],
          lon: r.prefs.data['lon'],
          pets: r.prefs.data['pets'] ?? [],
          likes: r.prefs.data['likes'] ?? [],
          conversations: r.prefs.data['conversations'] ?? [],
        );
        _loader.changeLoadingStatus(false);
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const InitializationView(),
          ),
          (route) => false,
        );
      },
    );
  }
}
// -----------------------------------------------------------------------------

final authControllerProvider =
    StateNotifierProvider<AuthControllerNotifier, UserModel>((ref) {
  final authApi = ref.watch(authApiProvider);
  final loader = ref.watch(loadingProvider.notifier);
  return AuthControllerNotifier(authApi: authApi, loader: loader);
});

final getCurrentAccountProvider = FutureProvider((ref) async {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getCurrentAccount();
});
