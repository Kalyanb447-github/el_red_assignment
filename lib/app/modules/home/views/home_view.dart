import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../main.dart';
import '../controllers/home_controller.dart';
import 'components/AddTaskPage.dart';
import 'components/ListTaskPage.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('${auth.currentUser!.email ?? ''}'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                auth.signOut();
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
      body: ListTaskPage(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTaskPage(),
            ),
          );
        },
        child: Icon(
          Icons.add,
          size: 40,
        ),
      ),
    );
  }
}
