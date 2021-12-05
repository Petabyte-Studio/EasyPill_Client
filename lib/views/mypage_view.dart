import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MypageView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MypageViewState();
}

class _MypageViewState extends State<MypageView> {
  FirebaseAuth auth = FirebaseAuth.instance;
  String? userEmail;
  Map<String, dynamic> userInfo = <String, dynamic>{};
  Map<String, dynamic> productInfo = <String, dynamic>{};

  bool? isNothing;
  int? subscribeCnt;

  @override
  void initState() {
    super.initState();
    userEmail = auth.currentUser?.email.toString();
    getUserData();
  }

  void logout() async => await auth.signOut();

  void getUserData() async {
    var url = 'http://127.0.0.1:8000/user/?search='+(auth.currentUser?.uid.toString() ?? '');
    var response = await http.get(Uri.parse(url));
    setState(() {
      var dataFromJSON = json.decode(utf8.decode(response.bodyBytes));
      userInfo = dataFromJSON[0];
      print(userInfo['subscriptions']);
      // subscribeCnt = userInfo['subscriptions'] == null ? 1 : userInfo['subscriptions'].length;
      subscribeCnt=userInfo['subscriptions'].length;
      if(subscribeCnt == 0) isNothing = true;
    });
    // getSubscriptionInfo();
  }

  // void getSubscriptionInfo() async{
  //   print("Num of subscription : $subscribeCnt");
  //   for(int i=0; i<subscribeCnt!; ++i){
  //     print(i);
  //     getProductData(userInfo['subscriptions'][i]['product'].toString(), i);
  //   }
  // }

  void getProductData(String pid, int i) async {
    var url = 'http://127.0.0.1:8000/product/'+pid;
    var response = await http.get(Uri.parse(url));
    setState(() {
      var dataFromJSON = json.decode(utf8.decode(response.bodyBytes));
      productInfo = dataFromJSON;
    });

  }

  void settingEntryTap(int settingID) {
    print(settingID);
    switch(settingID){
      case 1: Navigator.of(context).pushNamed('/mypage/subscribe'); break;
      case 2: Navigator.pop(context); break;
      case 3: break;
      case 4: break;
      case 5:
        logout();
        setState(() {
          userEmail = null;
        });
        Navigator.pop(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '마이페이지',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          child: Container(
            color: const Color(0xFFF1F1F1),
            height: 0.7,
          ),
          preferredSize: const Size.fromHeight(0.7),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 28),
        child: ListView(
          children: [
            Center(
              child: Stack(
                children: [
                  // profile image
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(userInfo['image'] ?? '')
                      )
                    )
                  ),
                  // edit icon
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        color: Color(0xff6FCF97), // sub color
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.edit,
                        size: 16.0,
                        color: Colors.white,
                      )
                    )
                  ),
                ],
              ),
            ),
            Center(
              child: Column(
                children: [
                  SizedBox(height: 15),
                  Text(
                    userInfo['name'].toString(),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 5),
                  Text(
                    userEmail ?? "먼저 로그인 하세요",
                    style: TextStyle(color: Color(0xff999999), fontSize: 14)
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: [
                  Text(
                    "구독중인 영양제",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                  ),
                ],
              )
            ),

            SingleChildScrollView(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  subscribeCardArea()
                ],
              ),
            ),

            Container(
              margin: EdgeInsets.only(top: 30),
              width: double.infinity,
              child: Divider(color: Color(0xffe7e7e7), thickness: 7.0)
            ),

            Container(
              padding: const EdgeInsets.only(left: 20, top: 30, right: 20),
              child: 
                Text(
                  "내 설정",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                ),
            ),

            Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: 
                Column(
                  children: [
                    buildSettingRow(context, "과거 구독이력보기", 1),
                    buildSettingRow(context, "알림설정", 2),
                    buildSettingRow(context, "FAQ", 3),
                    buildSettingRow(context, "이용약관", 4),
                    buildSettingRow(context, "로그아웃", 5)
                  ],
                )
            )
          ],
        )
      ),
    );
  }

  SizedBox subscribeCardArea() {
    if(isNothing == true){
      print("nothing exist");
      return SizedBox(
        child: Container(
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            children: [
              Text(
                "구독중인 영양제가 없습니다",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
            ],
          )
        ),
      );
    }
    else{
      return SizedBox(
        height: 100.0,
        child: PageView.builder(
          padEnds: false,
          itemCount: subscribeCnt,
          controller: PageController(viewportFraction: 0.55),
          itemBuilder: (BuildContext context, int index) {
            return buildCardItem(context, index);
          },
        ),
      );
    }
  }

  Widget buildCardItem(BuildContext context, int index) {
    var left_margin = 10.0;
    if(index == 0) left_margin = 20.0;

    var card = Container(
      margin: EdgeInsets.only(left: left_margin),
      child: Column(
        children: [
          Text(
            "subscription info #$index",
          ),
          Text(
            userInfo['subscriptions'][index]['product'].toString(),
          ),
          Text(
            userInfo['subscriptions'][index]['start_at'].toString().substring(0, 10),
          ),
          
        ]
      ),
      decoration: BoxDecoration(
        color: Color(0xFF999999), // 0xFFF9F9F9
        borderRadius: BorderRadius.circular(8),
      ),
    );
    return card;
  }

  GestureDetector buildSettingRow(BuildContext context, String title, int settingID) {
    return GestureDetector(
      // onTap : () => settingEntryTap(settingID),
      onTap: (){
        settingEntryTap(settingID);
        if(settingID==3 || settingID==4){
          showDialog(
            context: context, builder: (BuildContext context){
              return AlertDialog(
                title: Text(title),
                content: Text("준비중입니다")
              );
          });
        }
        
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 45),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 15.0,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }
}