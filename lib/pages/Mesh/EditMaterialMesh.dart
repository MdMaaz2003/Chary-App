import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UpdateScreenMesh extends StatefulWidget {
  final String id;
  const UpdateScreenMesh({Key? key, required this.id}) : super(key: key);

  @override
  _UpdateScreenMeshState createState() => _UpdateScreenMeshState();
}

class _UpdateScreenMeshState extends State<UpdateScreenMesh> {
  String dropdownValue = "Golden Brown";
  final _formKey = GlobalKey<FormState>();

  // Updating data
  CollectionReference mesh = FirebaseFirestore.instance.collection('mesh');

  Future<void> updateUser(id, name, color, quantity) {
    return mesh
        .doc(id)
        .update({'name': name, 'color': color, 'quantity': quantity})
        .then((value) => print("data Updated"))
        .catchError((error) => print("Failed to update data: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("MeshAdmin"),
        backgroundColor: Colors.black87,
      ),
      body: Form(
          key: _formKey,
          // Getting Specific Data by ID
          child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: FirebaseFirestore.instance
                .collection('mesh')
                .doc(widget.id)
                .get(),
            builder: (_, snapshot) {
              if (snapshot.hasError) {
                if (kDebugMode) {
                  print('Something Went Wrong');
                }
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              var data = snapshot.data!.data();
              var name = data!['name'];
              var color = data['color'];
              var quantity = data['quantity'].toString();
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                child: ListView(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      child: TextFormField(
                        initialValue: name,
                        autofocus: false,
                        onChanged: (value) => name = value,
                        decoration: const InputDecoration(
                          labelText: 'Name: ',
                          labelStyle: TextStyle(fontSize: 20.0),
                          border: OutlineInputBorder(),
                          errorStyle:
                              TextStyle(color: Colors.redAccent, fontSize: 15),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Name';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      child: TextFormField(
                        initialValue: quantity,
                        autofocus: false,
                        onChanged: (value) => quantity = value.toString(),
                        decoration: const InputDecoration(
                          labelText: 'Quantity: ',
                          labelStyle: TextStyle(fontSize: 20.0),
                          border: OutlineInputBorder(),
                          errorStyle:
                              TextStyle(color: Colors.redAccent, fontSize: 15),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                "Colors",
                                style: TextStyle(fontSize: 20),
                              ),
                              const SizedBox(
                                width: 100,
                              ),
                              DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  icon: const Icon(
                                    Icons.arrow_drop_down_circle_outlined,
                                    color: Colors.black38,
                                  ),
                                  value: dropdownValue,
                                  elevation: 0,
                                  style: const TextStyle(color: Colors.black87),
                                  onChanged: (String? newValue) {
                                    setState(
                                      () {
                                        dropdownValue = newValue!;
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
                                        child: Text(
                                            style:
                                                const TextStyle(fontSize: 16),
                                            value),
                                      );
                                    },
                                  ).toList(),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 350.0,
                            height: 1.0,
                            child: DecoratedBox(
                              decoration: BoxDecoration(color: Colors.black45),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Validate returns true if the form is valid, otherwise false.
                            if (_formKey.currentState!.validate()) {
                              updateUser(widget.id, name, dropdownValue,
                                  quantity.toString());
                              Navigator.pop(context);
                            }
                          },
                          child: const Text(
                            'Update',
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          )),
    );
  }
}
