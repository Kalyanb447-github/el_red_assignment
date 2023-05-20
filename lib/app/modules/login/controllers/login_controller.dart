import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../main.dart';
import '../../../routes/app_pages.dart';

const List<String> scopes = <String>[
  'email',
  'https://www.googleapis.com/auth/contacts.readonly',
];

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: 'your-client_id.apps.googleusercontent.com',
  scopes: scopes,
);

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GoogleSignInAccount? _currentUser;
  bool _isAuthorized = false; // has granted permissions?
  String _contactText = '';
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  googleSignInCheck() {
    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) async {
      // In mobile, being authenticated means being authorized...
      bool isAuthorized = account != null;

      _currentUser = account;
      _isAuthorized = isAuthorized;

      // Now that we know that the user can access the required scopes, the app
      // can call the REST API.
      if (isAuthorized) {
        // _handleGetContact(account!);
      }
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<dynamic> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult =
          await auth.signInWithCredential(credential);
      // final User? user = authResult.user;

      // if (user!.uid != null && user.uid.isNotEmpty) {
      //   Get.offAllNamed(Routes.HOME);
      // }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Something is wrong', e.message.toString());
    } catch (e) {
      Get.snackbar('Something is wrong', e.toString());
    }
  }

  login() async {
    try {
      UserCredential user = await auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      print(user);

      if (user.user!.uid != null && user.user!.uid.isNotEmpty) {
        Get.offAllNamed(Routes.HOME);
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Something is wrong', e.message.toString());
    } catch (e) {
      Get.snackbar('Something is wrong', e.toString());
    }
  }
}
