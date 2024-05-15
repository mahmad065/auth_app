import 'package:auth_app/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:auth_app/screens/home.dart';
import 'package:auth_app/screens/sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  // final auth = FirebaseAuth.instance;

  // void checkIfLogin() {
  //   auth.authStateChanges().listen((User? user) {
  //     if (user != null && mounted) {
  //       setState(() {
  //         isLogin = true;
  //       });
  //     }
  //   });
  // }

  // @override
  // void initState() {
  //   checkIfLogin();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStreamProvider);
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: authState.when(
          data: (user) {
            if (user != null) {
              return const HomeScreen();
            }
            return const SignInScreen();
          },
          loading: () {
            return const HomeScreen();
          },
          error: (error, stackTrace) {
            debugPrint(error.toString());
            return const HomeScreen();
          },
        ));
  }
}
