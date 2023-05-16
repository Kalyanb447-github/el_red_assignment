import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'UpdateTaskPage.dart';

class ListTaskPage extends StatefulWidget {
  ListTaskPage({Key? key}) : super(key: key);

  @override
  _ListTaskPageState createState() => _ListTaskPageState();
}

class _ListTaskPageState extends State<ListTaskPage> {
  final Stream<QuerySnapshot> toDoListsStream =
      FirebaseFirestore.instance.collection('ToDoList').snapshots();

  // For Deleting Task
  CollectionReference toDoList =
      FirebaseFirestore.instance.collection('ToDoList');
  Future<void> deleteTask(id) {
    return toDoList.doc(id).delete().then((value) {
      Get.snackbar('task Deleted', '', colorText: Colors.red);
    }).catchError((error) {
      Get.snackbar('Failed to Delete Task', '$error', colorText: Colors.red);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: toDoListsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print('Something went Wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final List storedocs = [];
        snapshot.data!.docs.map((DocumentSnapshot document) {
          Map a = document.data() as Map<String, dynamic>;
          storedocs.add(a);
          a['id'] = document.id;
        }).toList();

        return SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: storedocs.length,
                itemBuilder: (context, index) {
                  Map data = storedocs[index];
                  DateTime dateTime =
                      DateTime.fromMillisecondsSinceEpoch(data['date']);
                  final DateFormat formatter = DateFormat('dd-MM-yyyy');
                  final String formatted = formatter.format(dateTime);
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateTaskPage(id: data['id']),
                        ),
                      );
                    },
                    title: Text('${data['task_name']}'),
                    subtitle: Text('${data['desc']}\n $formatted'),
                    trailing: IconButton(
                        onPressed: () {
                          deleteTask(data['id']);
                        },
                        icon: Icon(Icons.delete)),
                  );
                },
              )
            ],
          ),
        );
      },
    );
  }
}
