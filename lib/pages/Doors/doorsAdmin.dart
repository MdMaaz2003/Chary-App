import 'package:chary/pages/Doors/EditMaterialDoors.dart';
import 'package:chary/screens/mainscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../screens/adminscreen.dart';
import 'AddMaterialDoors.dart';

class ListScreenDoorsAdmin extends StatefulWidget {
  const ListScreenDoorsAdmin({Key? key}) : super(key: key);

  @override
  State<ListScreenDoorsAdmin> createState() => _ListScreenDoorsAdmin();
}

class _ListScreenDoorsAdmin extends State<ListScreenDoorsAdmin> {
  String dropdownValue = "Golden Brown";
  var dropdownColor = "Golden Brown";

  final Stream<QuerySnapshot> doorStream =
      FirebaseFirestore.instance.collection('doors').snapshots();

  CollectionReference doors = FirebaseFirestore.instance.collection('doors');
  Future<void> deleteData(id) {
    // print("Data Deleted $id");
    return doors
        .doc(id)
        .delete()
        .then((value) => print('User Deleted'))
        .catchError((error) => print('Failed to Delete user: $error'));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: doorStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          if (kDebugMode) {
            print('Something went Wrong');
          }
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final List storedocs = [];
        snapshot.data!.docs.map((DocumentSnapshot document) {
          Map doorMap = document.data() as Map<String, dynamic>;
          storedocs.add(doorMap);
          doorMap['id'] = document.id;
        }).toList();
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text(
              "DoorsAdmin",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: calculateBackgroundColor(dropdownColor),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white70),
              onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AdminScreen(),
                  ),
                  (route) => false),
            ),
            actions: <Widget>[
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  // icon: const Icon(
                  //   Icons.filter_alt,
                  //   color: Colors.white70,
                  // ),
                  value: dropdownColor,
                  elevation: 0,
                  style: const TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.bold),
                  dropdownColor: Colors.white,
                  onChanged: (String? newValue) {
                    setState(
                      () {
                        dropdownValue = newValue!;
                        dropdownColor = newValue;
                        // print(dropdownColor);
                      },
                    );
                  },
                  items: <String>[
                    "Golden Brown",
                    "Dark Brown",
                    "Honey Gold",
                    "White"
                  ].map<DropdownMenuItem<String>>(
                    (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child:
                            Text(style: const TextStyle(fontSize: 16), value),
                      );
                    },
                  ).toList(),
                ),
              ),
              const SizedBox(
                width: 10,
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.black87,
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AddMaterialDoors(),
                  ),
                  (route) => false);
            },
            child: const Icon(Icons.add),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              for (var i = 0; i < storedocs.length; i++) ...[
                if (dropdownValue.isEmpty) ...{
                  Container(
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.black,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black54,
                              blurRadius: 5.0,
                              offset: Offset(3.0, 3.0))
                        ]),
                    height: 50.0,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          storedocs[i]['name'],
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(
                          width: 18.0,
                        ),
                        Text(
                          storedocs[i]['quantity'],
                          style: const TextStyle(fontSize: 20),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            IconButton(
                              onPressed: () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UpdateScreenDoors(
                                        id: storedocs[i]['id']),
                                  ),
                                )
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.black38,
                              ),
                            ),
                            IconButton(
                              onPressed: () => {
                                deleteData(
                                  storedocs[i]['id'],
                                ),
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                } else if (storedocs[i]["color"] == dropdownValue) ...{
                  Container(
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.black,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black54,
                              blurRadius: 5.0,
                              offset: Offset(3.0, 3.0))
                        ]),
                    height: 50.0,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          storedocs[i]['name'],
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(
                          width: 18.0,
                        ),
                        Text(
                          storedocs[i]['quantity'],
                          style: const TextStyle(fontSize: 20),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            IconButton(
                              onPressed: () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UpdateScreenDoors(
                                        id: storedocs[i]['id']),
                                  ),
                                )
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.black38,
                              ),
                            ),
                            IconButton(
                              onPressed: () => {
                                deleteData(
                                  storedocs[i]['id'],
                                ),
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                },
              ],
            ],
          ),
        );
      },
    );
  }
}

Color? calculateBackgroundColor(String dropdownColor) {
  if (dropdownColor == "Golden Brown") {
    return Colors.brown;
  } else if (dropdownColor == "Dark Brown") {
    return Colors.brown[900];
  } else if (dropdownColor == "Honey Gold") {
    return Colors.yellow[800];
  } else if (dropdownColor == "White") {
    return Colors.black12;
  } else {
    return Colors.black87;
  }
}
