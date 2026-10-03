import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shoping_app/firebase_options.dart';
import 'package:shoping_app/register.dart';
import 'package:shoping_app/login.dart';
import 'package:shoping_app/dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      initialRoute: '/register',

      routes: {
        '/register': (context) => const Register(),
        '/login': (context) => const Login(),
        '/dashboard': (context) => const Dashboard(),
      },
    );
  }
}
