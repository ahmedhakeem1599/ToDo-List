import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Screens/home_screen.dart';
import 'Screens/intro_screen.dart';
import 'Screens/login_screen.dart';
import 'Screens/register_screen.dart';
import 'service/controller_bindings.dart';
import 'service/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Listen to auth state changes (optional, for debugging)
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          initialBinding: ControllerBindings(),
          home: (FirebaseAuth.instance.currentUser != null) ? HomeScreen() : IntroScreen(),
          getPages: [
            GetPage(name: '/intro', page: () => IntroScreen()),
            GetPage(name: '/home', page: () => HomeScreen()),
            GetPage(name: '/register', page: () => RegisterScreen()),
            GetPage(name: '/login', page: () => LoginScreen()),
          ],
    );
  }
}