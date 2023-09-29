import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuncchat/common/widgets/error.dart';
import 'package:tuncchat/common/widgets/loader.dart';
import 'package:tuncchat/screens/auth/controller/auth_controller.dart';
import 'package:tuncchat/screens/screens.dart';
import 'package:tuncchat/utils/router.dart';
import 'package:tuncchat/utils/utils.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Whatsapp UI',
      theme: ThemeData(
        iconTheme: const IconThemeData(color: textColor),
        scaffoldBackgroundColor: backgroundColor,
      ),
      onGenerateRoute: (initialRoute) => generateRoute(initialRoute),
      home: ref.watch(userDataAuthProvider).when(
            data: (user) {
              if (user == null) {
                return const LandingScreen();
              }
              return const MobileLayoutScreen();
            },
            error: (err, trace) {
              return ErrorScreen(error: err.toString());
            },
            loading: () => const Loader(),
          ),
    );
  }
}
