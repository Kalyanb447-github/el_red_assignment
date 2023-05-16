import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UpdateTaskPage extends StatefulWidget {
  final String id;
  UpdateTaskPage({Key? key, required this.id}) : super(key: key);

  @override
  _UpdateTaskPageState createState() => _UpdateTaskPageState();
}

class _UpdateTaskPageState extends State<UpdateTaskPage> {
  final _formKey = GlobalKey<FormState>();

  CollectionReference toDoLists =
      FirebaseFirestore.instance.collection('ToDoList');

  final taskNameController = TextEditingController();
  final descController = TextEditingController();
  final dateController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;

      final DateFormat formatter = DateFormat('dd-MM-yyyy');
      final String formatted = formatter.format(selectedDate);

      dateController.text = formatted;
    }
  }

  Future<void> updateTask(id) {
    return toDoLists.doc(id).update({
      'task_name': taskNameController.text,
      'desc': descController.text,
      'date': selectedDate.millisecondsSinceEpoch,
    }).then((value) {
      Get.snackbar('task updated', '', colorText: Colors.green);
    }).catchError((error) {
      Get.snackbar('Failed to task updated', '$error', colorText: Colors.red);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Task"),
      ),
      body: Form(
          key: _formKey,
          // Getting Specific Data by ID
          child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: FirebaseFirestore.instance
                .collection('ToDoList')
                .doc(widget.id)
                .get(),
            builder: (_, snapshot) {
              if (snapshot.hasError) {
                print('Something Went Wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              var data = snapshot.data!.data();

              taskNameController.text = data!['task_name'];
              descController.text = data['desc'];

              DateTime dateTime =
                  DateTime.fromMillisecondsSinceEpoch(data['date']);
              final DateFormat formatter = DateFormat('dd-MM-yyyy');
              final String formatted = formatter.format(dateTime);

              dateController.text = formatted;
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                child: ListView(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: TextFormField(
                        controller: taskNameController,
                        autofocus: false,
                        decoration: InputDecoration(
                          labelText: 'Task : ',
                          labelStyle: TextStyle(fontSize: 20.0),
                          border: OutlineInputBorder(),
                          errorStyle:
                              TextStyle(color: Colors.redAccent, fontSize: 15),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Task';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: TextFormField(
                        controller: descController,
                        autofocus: false,
                        decoration: InputDecoration(
                          labelText: 'desc: ',
                          labelStyle: TextStyle(fontSize: 20.0),
                          border: OutlineInputBorder(),
                          errorStyle:
                              TextStyle(color: Colors.redAccent, fontSize: 15),
                        ),
                      ),
                    ),
                    TextField(
                      controller:
                          dateController, //editing controller of this TextField
                      decoration: const InputDecoration(
                          icon: Icon(Icons.calendar_today), //icon of text field
                          labelText: "Enter Date" //label text of field
                          ),
                      readOnly: true, // when true task cannot edit text
                      onTap: () async {
                        _selectDate(context);
                      },
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Validate returns true if the form is valid, otherwise false.
                              if (_formKey.currentState!.validate()) {
                                updateTask(widget.id);
                                Navigator.pop(context);
                              }
                            },
                            child: Text(
                              'Update',
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => {},
                            child: Text(
                              'Reset',
                              style: TextStyle(fontSize: 18.0),
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blueGrey),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          )),
    );
  }
}
