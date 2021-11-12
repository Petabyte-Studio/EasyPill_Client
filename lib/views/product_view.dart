import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductView extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _ProductView();
  }
}

Future<String> fetchPost() async {
  var response = await http.get(Uri.parse('http://10.0.2.2:8000/product'));
  return utf8.decode(response.bodyBytes);
}

class _ProductView extends State<ProductView> {
  String test = 'Before Add';

  void foo() async {
    final value = await fetchPost();
    setState(() {
      test = value;
    });

    print(value);
  }

  @override
  Widget build(BuildContext context) {
    print('fuck you');
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text('P'),
          ),
          body: Column(children: <Widget>[
            ElevatedButton(
              child: Text('FETCH'),
              onPressed: () => foo(),
            ),
            Text('$test'),
          ])),
    );
  }
}
