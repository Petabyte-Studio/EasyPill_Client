import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'dart:convert';
import 'views/views.dart';
import 'views/widgets/home_grid_widget.dart';
import 'views/widgets/category_grid_widget.dart';
import 'views/widgets/main_header.dart';
import 'views/widgets/new_product_card.dart';
import 'views/widgets/recommend_card.dart';
import 'views/widgets/main_footer.dart';

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
  final DateTime _today =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  FirebaseAuth auth = FirebaseAuth.instance;
  List? recommendData;
  List? newData;
  Map<String, dynamic> userInfo = <String, dynamic>{};

  @override
  void initState() {
    super.initState();
    recommendData = List.empty(growable: true);
    newData = List.empty(growable: true);
    getJSONData();
    getUserData();
  }

  void getJSONData() async {
    var url =
        'http://49.247.147.204:8000/product/?search_fields=category&search=&ordering=-avg_rate';
    var response1 = await http.get(Uri.parse(url));
    url =
        'http://49.247.147.204:8000/product/?search_fields=category&search=&ordering=-created_at';
    var response2 = await http.get(Uri.parse(url));
    setState(() {
      recommendData!.addAll(json.decode(utf8.decode(response1.bodyBytes)));
      newData!.addAll(json.decode(utf8.decode(response2.bodyBytes)));
    });
  }

  void getUserData() async {
    var url = 'http://49.247.147.204:8000/user/?search=' +
        (auth.currentUser?.uid.toString() ?? '');
    var response = await http.get(Uri.parse(url));
    setState(() {
      var parsed = json.decode(utf8.decode(response.bodyBytes));
      userInfo = parsed[0];
    });
  }

  Widget sessionTitle({
    required String title,
    required Function callback,
  }) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF212529),
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 15),
          ],
        ),
      ),
      onTap: () {
        callback();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Color(0xFF6FCF97),
        ),
      ),
      body: ListView(
        children: <Widget>[
          MainHeader(
            userName: userInfo['name'].toString(),
            userImage: userInfo['image'].toString(),
            age: 25,
            sex: '남',
            address: '동작구',
            eatTimes: [
              DateTime(_today.year, _today.month, _today.day, 8, 30),
              DateTime(_today.year, _today.month, _today.day, 13, 30),
              DateTime(_today.year, _today.month, _today.day, 20, 30),
            ],
            ateList: [false, false, false],
          ),
          sessionTitle(title: "제품 추천", callback: () {}),
          SingleChildScrollView(
            // padding: const EdgeInsets.only(top: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 210.0,
                  child: PageView.builder(
                    padEnds: false,
                    itemCount: (recommendData!.length > 5
                        ? 5
                        : recommendData!.length), // 최대 5개 표시
                    controller: PageController(viewportFraction: 0.6),
                    itemBuilder: (context, index) => RecommendCard(
                      data: recommendData![index],
                      idx: index,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          HomeGridWidget(
            titles: ['새로 들어온\n멀티비타민', '지금 가장 핫한\n인기순위'],
            subtitles: ['제품 보러가기', '순위 보러가기'],
            backgroundColors: [
              const Color(0xFFFFEDE9).withOpacity(0.9),
              const Color(0xFFEAEFFB).withOpacity(0.8),
            ],
            textColors: [
              const Color(0xFF994A00),
              const Color(0xFF2D457E),
            ],
            icons: [
              'assets/images/medicine_character.svg',
              'assets/images/gold_cup.svg',
            ],
            callbacks: [
              () => Navigator.of(context)
                  .pushNamed('/category/product', arguments: '>2멀티비타민'),
              () => Navigator.of(context)
                  .pushNamed('/category/product', arguments: '>1전체보기'),
            ],
          ),
          const SizedBox(height: 20),
          sessionTitle(title: "이번에 새로 나왔어요!", callback: () {}),
          SingleChildScrollView(
            // padding: const EdgeInsets.only(top: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 120.0,
                  child: PageView.builder(
                    padEnds: false,
                    itemCount: (newData!.length > 5 ? 5 : newData!.length),
                    controller: PageController(viewportFraction: 0.7),
                    itemBuilder: (context, index) => NewProductCard(
                      data: newData![index],
                      idx: index,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          CategoryGrid(),
          const SizedBox(height: 33),
          MainFooter(),
        ],
      ),
    );
  }
}
