import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'doorsAdmin.dart';

class AddMaterialDoors extends StatefulWidget {
  const AddMaterialDoors({Key? key}) : super(key: key);

  @override
  _AddMaterialDoorsState createState() => _AddMaterialDoorsState();
}

class _AddMaterialDoorsState extends State<AddMaterialDoors> {
  String dropdownValue = "Golden Brown";
  final _formKey = GlobalKey<FormState>();
  var name = "";
  var color = "";
  var quantity = "";
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final nameController = TextEditingController();
  final colorController = TextEditingController();
  final quantityController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    colorController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  clearText() {
    nameController.clear();
    colorController.clear();
    quantityController.clear();
  }

  // Adding data
  CollectionReference doors = FirebaseFirestore.instance.collection('doors');

  Future<void> addData() {
    return doors
        .add({'name': name, 'color': color, 'quantity': quantity})
        .then((value) => print('Data Added'))
        .catchError((error) => print('Failed to Add data: $error'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("DoorsAdmin"),
        backgroundColor: Colors.black87,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white70),
          onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => const ListScreenDoorsAdmin(),
              ),
              (route) => false),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: ListView(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                  maxLength: 15,
                  autofocus: false,
                  decoration: const InputDecoration(
                    labelText: 'Name: ',
                    labelStyle: TextStyle(fontSize: 20.0),
                    errorStyle:
                        TextStyle(color: Colors.redAccent, fontSize: 15),
                  ),
                  controller: nameController,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(15),
                  ],
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
                  autofocus: false,
                  decoration: const InputDecoration(
                    labelText: 'Quantity: ',
                    labelStyle: TextStyle(fontSize: 20.0),
                    errorStyle:
                        TextStyle(color: Colors.redAccent, fontSize: 15),
                  ),
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(50000),
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  validator: (String? text) {
                    if (text == null || text.isEmpty) {
                      return 'Please Enter Quantity';
                    }
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                margin: const EdgeInsets.symmetric(vertical: 30.0),
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
                                      style: const TextStyle(fontSize: 16),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, otherwise false.
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          name = nameController.text;
                          color = dropdownValue;
                          quantity = quantityController.text;
                          addData();
                          clearText();
                        });
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ListScreenDoorsAdmin()),
                            (route) => false);
                      }
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => {clearText()},
                    style: ElevatedButton.styleFrom(primary: Colors.blueGrey),
                    child: const Text(
                      'Reset',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
