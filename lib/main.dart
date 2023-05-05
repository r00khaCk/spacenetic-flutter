import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:spacenetic_flutter/UI/pages/home_swipe_view.dart';
import 'package:spacenetic_flutter/UI/pages/homepage.dart';
import 'package:spacenetic_flutter/UI/pages/signin_page.dart';
import 'package:spacenetic_flutter/UI/pages/signup_page.dart';
import 'package:spacenetic_flutter/UI/pages/splashscreen.dart';
import 'package:spacenetic_flutter/UI/pages/timeline_page.dart';
import 'package:spacenetic_flutter/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const SplashscreenPage(),
      routes: {
        '/main': (context) => const SplashscreenPage(),
        '/home': (context) => const MyHomeSwipeView(),
        '/signin': (context) => const SignInPage(),
        'signup': (context) => const SignUpPage(),
        '/timeline': (context) => const TimelinePage(),
      },
    );
  }
}
