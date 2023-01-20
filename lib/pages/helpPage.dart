import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/adminscreen.dart';
import '../screens/mainscreen.dart';

void main() => runApp(
      const HelpPage(),
    );

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  Null _selectedQuestion;
  String role = 'user';
  get child => null;
  @override
  void initState() {
    super.initState();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help'),
        backgroundColor: Colors.black87,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white70),
          onPressed: () => _checkRole(),
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
                margin: const EdgeInsets.all(25),
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Respond to button press
                  },
                  icon: const Icon(Icons.report, size: 18),
                  label: const Text("Report A Problem"),
                )),
            Container(
                margin: const EdgeInsets.all(25),
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Respond to button press
                  },
                  icon: const Icon(Icons.help_center, size: 18),
                  label: const Text("Help Center"),
                )),
            Container(
                margin: const EdgeInsets.all(25),
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Respond to button press
                  },
                  icon: const Icon(Icons.privacy_tip, size: 18),
                  label: const Text("Privacy And Security Help"),
                )),
            DropdownButton(
              value: _selectedQuestion,
              items: _dropDownItem(),
              onChanged: (value) {
                _selectedQuestion = value as Null;
                setState(() {});
              },
              hint: const Text('FAQs'),
            ),
          ],
        ),
      ),
    );
  }
}

List<DropdownMenuItem<String>> _dropDownItem() {
  List<String> ddl = ["Question1", "Question2", "Question3"];
  return ddl
      .map((value) => DropdownMenuItem(
            value: value,
            child: Text(value),
          ))
      .toList();
}
