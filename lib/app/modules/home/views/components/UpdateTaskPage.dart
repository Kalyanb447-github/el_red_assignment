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
      backgroundColor: Color(0xFF46539e),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xFF587fc8)),
        elevation: 0,
        backgroundColor: Color(0xFF46539e),
        title: Text("Update Task"),
        centerTitle: true,
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
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Task : ',
                          labelStyle:
                              TextStyle(fontSize: 20.0, color: Colors.white),
                          errorStyle:
                              TextStyle(color: Colors.redAccent, fontSize: 15),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
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
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Description : ',
                          labelStyle:
                              TextStyle(fontSize: 20.0, color: Colors.white),
                          errorStyle:
                              TextStyle(color: Colors.redAccent, fontSize: 15),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller:
                          dateController, //editing controller of this TextField
                      style: TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        icon: Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                        ), //icon of text field
                        labelText: "Select Date", //label text of field,
                        labelStyle:
                            TextStyle(fontSize: 20.0, color: Colors.white),

                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),

                      readOnly: true, // when true task cannot edit text
                      onTap: () async {
                        _selectDate(context);
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          // Validate returns true if the form is valid, otherwise false.
                          if (_formKey.currentState!.validate()) {
                            updateTask(widget.id);
                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                          'UPDATE TASK',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          )),
    );
  }
}
