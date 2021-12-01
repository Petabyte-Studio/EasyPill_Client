import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductView extends StatefulWidget {
  State<StatefulWidget> createState() => _ProductView();
}

class _ProductView extends State<ProductView> {
  String test = 'Before Add';
  List? data;
  var category;
  @override
  void initState() {
    super.initState();
    data = List.empty(growable: true);
    Future.delayed(Duration.zero, () {
      setState(() {
        category = ModalRoute.of(context)!.settings.arguments;
        getJSONData(category);
      });
    });
  }

  void getJSONData(var category) async {
    var url = 'http://127.0.0.1:8000/product/?search_fields=category&search=' +
        category;
    var response = await http.get(Uri.parse(url));
    setState(() {
      var dataFromJSON = json.decode(utf8.decode(response.bodyBytes));
      data!.addAll(dataFromJSON);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category ?? '로딩 중..'),
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
        child: data!.length == 0
            ? Text('데이터가 없습니다', style: TextStyle(fontSize: 20))
            : ListView.builder(
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: Card(
                      child: Column(
                        children: <Widget>[
                          Text(data![index]['id'].toString()),
                          Text(data![index]['name'].toString()),
                          Text(data![index]['company'].toString()),
                          Text(data![index]['price'].toString()),
                          Text((data![index]['avg_rate'] ?? 0.0)
                              .toStringAsFixed(2)),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                          '/category/product/detail',
                          arguments: data![index]['id'].toString());
                    },
                  );
                },
                itemCount: data!.length),
      ),
    );
  }
}


// ListView.builder(
//                     itemBuilder: (context, index) {
//                       return Card(
//                           child: Container(
//                               child: Column(
//                         children: <Widget>[
//                           Text(data![index]['id'].toString()),
//                           Text(data![index]['name'].toString()),
//                           Text(data![index]['company'].toString()),
//                           Text(data![index]['price'].toString()),
//                           Text(data![index]['rate'].toString()),
//                         ],
//                       )));
//                     },
//                     itemCount: data!.length),