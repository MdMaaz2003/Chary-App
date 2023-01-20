import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../screens/mainscreen.dart';

class ListScreenMesh extends StatefulWidget {
  const ListScreenMesh({Key? key}) : super(key: key);

  @override
  State<ListScreenMesh> createState() => _ListScreenMesh();
}

class _ListScreenMesh extends State<ListScreenMesh> {
  String dropdownValue = 'Cream';
  var dropdownColor = "Cream";

  final Stream<QuerySnapshot> meshStream =
      FirebaseFirestore.instance.collection('mesh').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: meshStream,
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
            Map meshMap = document.data() as Map<String, dynamic>;
            storedocs.add(meshMap);
            meshMap['id'] = document.id;
          }).toList();

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text(
                "MeshUser",
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: calculateBackgroundColor(dropdownColor),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black54),
                onPressed: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HomePage(),
                    ),
                    (route) => false),
              ),
              actions: <Widget>[
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    // icon: const Icon(Icons.filter_alt),
                    elevation: 0,
                    value: dropdownColor,
                    style: const TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.bold),
                    onChanged: (String? newValue) {
                      setState(
                        () {
                          dropdownValue = newValue!;
                          dropdownColor = newValue;
                        },
                      );
                    },
                    items: <String>[
                      'Cream',
                      'Grey',
                      'Black',
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
                        ],
                      ),
                    ),
                  },
                ],
              ],
            ),
          );
        });
  }
}

Color? calculateBackgroundColor(String dropdownColor) {
  if (dropdownColor == "Cream") {
    return Colors.yellow[50];
  } else if (dropdownColor == "Grey") {
    return Colors.grey;
  } else if (dropdownColor == "Black") {
    return Colors.black54;
  } else {
    return Colors.black87;
  }
}
