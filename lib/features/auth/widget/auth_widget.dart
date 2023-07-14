import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/error_page.dart';
import '../../../common/loading_page.dart';
import '../../initialization/view/initialization_view.dart';
import '../controller/auth_controller.dart';
import '../view/auth_phone_view.dart';

class AuthWidget extends ConsumerWidget {
  const AuthWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getCurrentAccountProvider).when(
          data: (user) {
            if (user != null) {
              return const InitializationView();
            }

            return const AuthPhoneView();
          },
          error: (error, stackTrace) => ErrorPage(error: error.toString()),
          loading: () => const LoadingPage(),
        );
  }
}
