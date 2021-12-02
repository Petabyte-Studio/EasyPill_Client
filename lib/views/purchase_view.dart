import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:collection';
import 'package:http/http.dart' as http;

class PurchaseView extends StatefulWidget {
  State<StatefulWidget> createState() => _PurchaseView();
}

class _PurchaseView extends State<PurchaseView> {
  String test = 'Before Add';
  List? data;
  Map<String, int> productInfo = {"KIRKLAND 비타민 C": 1, "숭실비타민": 2};

  @override
  void initState() {
    super.initState();
    data = List.empty(growable: true);
    getJSONData();
  }

  void getJSONData() async {
    String url;
    for (int i = 0; i < productInfo.length; i++) {
      url = 'http://127.0.0.1:8000/product?search=' +
          productInfo.keys.elementAt(i).toString() +
          '&search_fields=name';
      var response = await http.get(Uri.parse(url));
      setState(() {
        var dataFromJSON = json.decode(utf8.decode(response.bodyBytes));
        data!.addAll(dataFromJSON);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('주문페이지'),
        backgroundColor: Color(0xFFFFFFFF),
        elevation: 0.5,
      ),
      body: Container(
          child: ListView(children: <Widget>[
        Container(
            margin: EdgeInsets.only(left: 20, top: 20),
            child: Text('주문상품 (' + productInfo.length.toString() + ')',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
        ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return GestureDetector(
                child: Row(
                  children: <Widget>[
                    SizedBox(height: 120),
                    Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Image(
                          image: NetworkImage(data![index]['image'].toString()),
                          height: 90,
                          width: 90,
                        )),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Text(
                                data![index]['name'].toString(),
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              )),
                          Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Text(
                                data![index]['company'].toString(),
                                textAlign: TextAlign.left,
                                style: TextStyle(color: Colors.grey),
                              )),
                          SizedBox(height: 10),
                          Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Text(
                                data![index]['price'].toString() + '원',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              )),
                          Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Text(
                                  data![index]['description'].toString(),
                                  textAlign: TextAlign.left)),
                        ]),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).pushNamed('/detail',
                      arguments: data![index]['id'].toString());
                },
              );
            },
            itemCount: data!.length),
        Container(
            width: double.infinity,
            child: Divider(color: Color(248259250), thickness: 10.0))
      ])),
    );
  }
}
