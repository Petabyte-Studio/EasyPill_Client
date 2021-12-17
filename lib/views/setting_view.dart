import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
  Map<String, dynamic> userInfo = <String, dynamic>{};

  @override
  void initState() {
    super.initState();
    userEmail = auth.currentUser?.email.toString();
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

  void getUserData() async {
    var url = 'http://49.247.147.204:8000/user/?search=' +
        (auth.currentUser?.uid.toString() ?? '');
    var response = await http.get(Uri.parse(url));
    setState(() {
      var dataFromJSON = json.decode(utf8.decode(response.bodyBytes));
      userInfo = dataFromJSON[0];
    });
  }

  void postUserData() async {
    var url = 'http://49.247.147.204:8000/user/';
    http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'uid': auth.currentUser?.uid.toString() ?? 'null',
        'name': 'TEST MAN'
      }),
    );
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
                ElevatedButton(
                    child: Text('GET'),
                    onPressed: () {
                      getUserData();
                    }),
                ElevatedButton(
                    child: Text('POST'),
                    onPressed: () {
                      postUserData();
                    }),
              ],
            ),
            TextField(controller: emailText),
            TextField(obscureText: true, controller: passwordText),
            Text(userEmail ?? 'Signed Out'),
            Text(
                '============================\nUSER INFO FROM DJANGO SERVER\n============================'),
            Text(userInfo['uid'].toString()),
            Text(userInfo['name'].toString()),
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(userInfo['image'] ?? ''),
            ),
          ],
        ),
      ),
    );
  }
}
