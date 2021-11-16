import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  TextEditingController emailText = TextEditingController();
  TextEditingController passwordText = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  String? userEmail;

  @override
  void initState() {
    super.initState();
  }

  void login(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  void logout() async => await auth.signOut();

  void loginCheck() {
    auth.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently not logged in\n');
      } else {
        print('User is now logged in\n');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Setting'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                ElevatedButton(
                  child: Text('Login'),
                  onPressed: () {
                    login(emailText.value.text.toString(),
                        passwordText.value.text.toString());
                    loginCheck();
                    setState(() {
                      userEmail = auth.currentUser?.email.toString();
                    });
                  },
                ),
                ElevatedButton(
                  child: Text('Logout'),
                  onPressed: () {
                    logout();
                    setState(() {
                      userEmail = null;
                    });
                  },
                ),
              ],
            ),
            TextField(controller: emailText),
            TextField(obscureText: true, controller: passwordText),
            Text(userEmail ?? 'Signed Out'),
          ],
        ),
      ),
    );
  }
}
