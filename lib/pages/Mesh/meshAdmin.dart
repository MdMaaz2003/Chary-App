import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../screens/adminscreen.dart';
import 'AddMaterialMesh.dart';
import 'EditMaterialMesh.dart';

class ListScreenMeshAdmin extends StatefulWidget {
  const ListScreenMeshAdmin({Key? key}) : super(key: key);

  @override
  State<ListScreenMeshAdmin> createState() => _ListScreenMeshAdmin();
}

class _ListScreenMeshAdmin extends State<ListScreenMeshAdmin> {
  String dropdownValue = 'Cream';
  var dropdownColor = "Cream";

  final Stream<QuerySnapshot> meshStream =
      FirebaseFirestore.instance.collection('mesh').snapshots();

  CollectionReference mesh = FirebaseFirestore.instance.collection('mesh');
  Future<void> deleteData(id) {
    // print("Data Deleted $id");
    return mesh
        .doc(id)
        .delete()
        .then((value) => print('User Deleted'))
        .catchError((error) => print('Failed to Delete user: $error'));
  }

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
                "MeshAdmin",
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: calculateBackgroundColor(dropdownColor),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black54),
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
                    value: dropdownColor,
                    elevation: 0,
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
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
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.black87,
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddMaterialMesh(),
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
                                      builder: (context) => UpdateScreenMesh(
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
                                      builder: (context) => UpdateScreenMesh(
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
