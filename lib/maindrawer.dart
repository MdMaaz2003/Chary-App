import 'package:chary/pages/helpPage.dart';
import 'package:chary/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  String name = 'hello';
  @override
  void initState() {
    super.initState();
    _checkRole();
  }

  void _checkRole() async {
    User? user = FirebaseAuth.instance.currentUser;
    final DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();

    setState(() {
      name = snap['firstname'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              size: 90.0,
              Icons.person,
              color: Colors.black,
            ),
            const SizedBox(
              height: 5.0,
            ),
            Text(
              // storedocs[1]['firstname'],
              name,
              style: const TextStyle(
                  fontFamily: "Oswald",
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0),
            ),
            const SizedBox(
              height: 5.0,
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 20.0,
      ),
      //Now let's Add the button for the Menu
      //and let's copy that and modify it
      ListTile(
        onTap: () {},
        leading: const Icon(
          Icons.person,
          color: Colors.black,
        ),
        title: const Text("Your Profile"),
      ),

      ListTile(
        onTap: () {},
        leading: const Icon(
          Icons.notifications,
          color: Colors.black,
        ),
        title: const Text("Notifications"),
      ),

      ListTile(
        onTap: () {},
        leading: const Icon(
          Icons.settings_sharp,
          color: Colors.black,
        ),
        title: const Text("Settings"),
      ),

      ListTile(
        onTap: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HelpPage(),
            ),
          );
        },
        leading: const Icon(
          Icons.help,
          color: Colors.black,
        ),
        title: const Text("Help"),
      ),
      const Divider(
        color: Colors.black54,
      ),
      ListTile(
        onTap: () {
          FirebaseAuth.instance.signOut();
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginPage(title: "Chary"),
            ),
          );
        },
        leading: const Icon(
          Icons.logout,
          color: Colors.black,
        ),
        title: const Text("Logout"),
      ),
    ]);
  }
}
