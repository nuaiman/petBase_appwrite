import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'common/error_page.dart';
import 'common/loading_page.dart';
import 'features/auth/controller/auth_controller.dart';
import 'features/auth/view/auth_phone_view.dart';
import 'features/initialization/view/initialization_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'PetBase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Ubuntu',
      ).copyWith(
        useMaterial3: true,
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: const Color.fromARGB(0, 255, 255, 255).withAlpha(0),
        ),
      ),
      home: ref.watch(getCurrentAccountProvider).when(
            data: (user) {
              if (user != null) {
                return const InitializationView();
              }

              return const AuthPhoneView();
            },
            error: (error, stackTrace) => ErrorPage(error: error.toString()),
            loading: () => const LoadingPage(),
          ),
    );
  }
}
