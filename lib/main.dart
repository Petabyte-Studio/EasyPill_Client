import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'views/views.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Future<Database> initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'pill_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE eat_table(id INTEGER PRIMARY KEY AUTOINCREMENT, eatDate DATETIME, pillName TEXT, completed BOOLEAN, time INTEGER)",
        );
      },
      version: 1,
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Future<Database> database = initDatabase();

    return MaterialApp(
        title: 'EasyPill',
        theme: ThemeData(
          primarySwatch: createMaterialColor(const Color(0xFF6FCF97)),
          scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => MainPage(),
          '/category': (context) => CategoryView(),
          '/category/product': (context) => ProductListView(),
          '/category/product/detail': (context) => DetailView(),
          '/category/product/detail/comment': (context) => CommentView(),
          '/setting': (context) => SettingView(),
          '/eat': (context) => EatView(database),
          '/mypage': (context) => MypageView(),
          '/basket': (context) => BasketView(),
          // '/detail' :
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
                Navigator.of(context).pushNamed('/category');
              }),
          ElevatedButton(
              child: Text('Setting'),
              onPressed: () {
                Navigator.of(context).pushNamed('/setting');
              }),
          ElevatedButton(
              child: Text('Funny'),
              onPressed: () {
                Navigator.of(context).pushNamed('/eat');
              }),
          ElevatedButton(
              child: Text('Mypage'),
              onPressed: () {
                Navigator.of(context).pushNamed('/mypage');
              }),
          ElevatedButton(
              child: Text('Basket'),
              onPressed: () {
                Navigator.of(context).pushNamed('/basket');
              }),
        ],
      ),
    );
  }
}
