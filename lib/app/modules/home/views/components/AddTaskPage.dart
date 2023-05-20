import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../main.dart';

class AddTaskPage extends StatefulWidget {
  AddTaskPage({Key? key}) : super(key: key);

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();

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

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    taskNameController.dispose();
    descController.dispose();
    super.dispose();
  }

  clearText() {
    taskNameController.clear();
    descController.clear();
  }

  // Adding to Do Lists
  CollectionReference toDoLists =
      FirebaseFirestore.instance.collection('ToDoList');

  Future<void> addTask() {
    return toDoLists.add({
      'task_name': taskNameController.text,
      'desc': descController.text,
      'date': selectedDate.millisecondsSinceEpoch,
      'user_id': auth.currentUser!.uid
    }).then((value) {
      Get.snackbar('task Added', '', colorText: Colors.green);
    }).catchError((error) {
      Get.snackbar('Failed to Add task', '$error', colorText: Colors.red);
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
        title: Text("Add new task"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.menu),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  child: Icon(Icons.task, color: Colors.blue),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    border: Border.all(
                      color: Colors.grey,
                      width: .5,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: TextFormField(
                    autofocus: false,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Task Name ',
                      labelStyle:
                          TextStyle(fontSize: 20.0, color: Colors.white),
                      errorStyle:
                          TextStyle(color: Colors.redAccent, fontSize: 15),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    controller: taskNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Task Name';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: TextFormField(
                    autofocus: false,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Description ',
                      labelStyle:
                          TextStyle(fontSize: 20.0, color: Colors.white),
                      errorStyle:
                          TextStyle(color: Colors.redAccent, fontSize: 15),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    controller: descController,
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
                    labelStyle: TextStyle(fontSize: 20.0, color: Colors.white),

                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),

                  readOnly: true, // when true task cannot edit text
                  onTap: () async {
                    _selectDate(context);
                    //when click we have to show the datepicker
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 50,
                  width: Get.width,
                  child: ElevatedButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, otherwise false.
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          addTask();
                          clearText();
                        });
                      }
                    },
                    child: Text(
                      'ADD YOUR TASK',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
