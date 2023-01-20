import 'dart:async';
import 'package:chary/screens/mainscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'adminscreen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String role = 'user';

  @override
  void initState() {
    super.initState();
    _checkRole();
    super.initState();
    Timer(const Duration(seconds: 5), () {
      if (FirebaseAuth.instance.currentUser == null) {
        // user not logged ==> Login Screen
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => const LoginPage(
                title: 'Chary',
              ),
            ),
            (route) => false);
      } else {
        // user already logged in ==> Home Screen
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const HomePage()),
            (route) => false);
      }
    });
  }

  void _checkRole() async {
    User? user = FirebaseAuth.instance.currentUser;
    final DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();

    setState(() {
      role = snap['role'];
    });

    if (role == 'user') {
      navigateNext(
        const HomePage(),
      );
    } else if (role == 'admin') {
      navigateNext(
        const AdminScreen(),
      );
    }
  }

  void navigateNext(Widget route) {
    Timer(
      const Duration(milliseconds: 500),
      () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => route));
      },
    );
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
