import 'package:agro_shopping/resource/remote/fire_data.dart';
import 'package:agro_shopping/screens/login_screen.dart';
import 'package:agro_shopping/screens/nav_wrapper.dart';
import 'package:agro_shopping/widget/exp_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
bool isSeller = false;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      userRef.get().then((value) {
        isSeller = value.data()?['isSeller'] ?? false;
      });
    }
    return MaterialApp(
      title: 'Agro Shop',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        primaryColor: Colors.lightGreen,
      ),
      home: ExpCheck(
        FirebaseAuth.instance.currentUser != null
            ? const NavigationWrapper()
            : const LoginScreen(),
      ),
      scaffoldMessengerKey: scaffoldMessengerKey,
    );
  }
}
