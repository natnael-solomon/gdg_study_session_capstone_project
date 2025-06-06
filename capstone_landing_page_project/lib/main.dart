import 'package:capstone_landing_page_project/UserDashboard.dart';
import 'package:flutter/material.dart';
import "package:capstone_landing_page_project/ProductPage.dart";
import "package:capstone_landing_page_project/ProfilePage.dart";
import "package:capstone_landing_page_project/auth/signup_page.dart";
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SignUpPage());
  }
}
