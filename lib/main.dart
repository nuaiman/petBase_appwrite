import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/auth/widget/auth_widget.dart';

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
      home: const AuthWidget(),
    );
  }
}
