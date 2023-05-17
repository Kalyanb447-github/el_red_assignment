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
    // return Scaffold(
    //   //1
    //   body: CustomScrollView(
    //     slivers: <Widget>[
    //       //2
    //       SliverAppBar(
    //         expandedHeight: Get.height * .25,
    //         flexibleSpace: FlexibleSpaceBar(
    //           background: Image.asset(
    //             'assets/appbar_image.png',
    //             fit: BoxFit.fill,
    //           ),
    //         ),
    //       ),
    //       //3

    //       ListTaskPage(),
    //     ],
    //   ),
    // );
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(Get.height * .25), // here the desired height
        child: AppBar(
          flexibleSpace: Image(
            image: AssetImage('assets/appbar_image.png'),
            fit: BoxFit.cover,
          ),
          backgroundColor: Colors.transparent,
        ),
      ),
      drawer: Drawer(
        backgroundColor: Color(0xFF46539e),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            ListTile(
              title: Text(
                '${auth.currentUser!.email ?? ''}',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                child: Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  auth.signOut();
                  // Update the state of the app.
                  // ...
                },
              ),
            ),
          ],
        ),
      ),
      body: ListTaskPage(),
      floatingActionButton: FloatingActionButton(
        elevation: 20,
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
