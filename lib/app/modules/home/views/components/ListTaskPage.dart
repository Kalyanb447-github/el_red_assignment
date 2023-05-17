import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../main.dart';
import 'UpdateTaskPage.dart';

class ListTaskPage extends StatefulWidget {
  ListTaskPage({Key? key}) : super(key: key);

  @override
  _ListTaskPageState createState() => _ListTaskPageState();
}

class _ListTaskPageState extends State<ListTaskPage> {
  final Stream<QuerySnapshot> toDoListsStream = FirebaseFirestore.instance
      .collection('ToDoList')
      .where('user_id', isEqualTo: auth.currentUser!.uid)
      .snapshots();

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 10),
                child: Text(
                  'TASKS',
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.bold),
                ),
              ),
              ListView.separated(
                padding: EdgeInsets.only(left: 20, right: 20),
                separatorBuilder: (context, index) {
                  return Divider(
                    color: Colors.grey,
                    height: 1,
                    thickness: .2,
                  );
                },
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
                    leading: Container(
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
                    title: Text(
                      '${data['task_name']}',
                      style: TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${data['desc']}'),
                    trailing: Column(
                      children: [
                        Text(
                          '$formatted',
                          style: TextStyle(color: Colors.grey, fontSize: 10),
                        ),
                        Expanded(
                          child: IconButton(
                            color: Colors.red.shade300,
                            onPressed: () {
                              deleteTask(data['id']);
                            },
                            icon: Icon(Icons.delete),
                          ),
                        ),
                      ],
                    ),
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
