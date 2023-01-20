import 'dart:async';
import 'package:chary/screens/mainscreen.dart';
import 'package:chary/screens/splashscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class LogSplashScreen extends StatefulWidget {
  const LogSplashScreen({super.key});

  @override
  _LogSplashScreenState createState() => _LogSplashScreenState();
}

class _LogSplashScreenState extends State<LogSplashScreen> {
  @override
  void initState() {
    super.initState();
    super.initState();
    onRefresh();
  }

  onRefresh() {
    setState(() {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => const LoginPage(
                  title: 'Chary',
                ),
              ),
              (route) => false);
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const SplashScreen()),
              (route) => false);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(top: 20),
          child: const CircularProgressIndicator(
            backgroundColor: Colors.black87,
            color: Colors.redAccent,
            strokeWidth: 10,
          )),
    );
  }
}
