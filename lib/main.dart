import 'package:flutter/material.dart';
import 'views/product_view.dart';
import 'views/setting_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'EasyPill',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => MainPage(),
          '/product': (context) => ProductView(),
          '/setting': (context) => SettingView()
        });
  }
}

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EasyPill'),
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          ElevatedButton(
              child: Text('Product'),
              onPressed: () {
                Navigator.of(context).pushNamed('/product');
              }),
          ElevatedButton(
              child: Text('Setting'),
              onPressed: () {
                Navigator.of(context).pushNamed('/setting');
              }),
        ],
      ),
    );
  }
}
