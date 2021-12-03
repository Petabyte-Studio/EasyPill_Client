import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DetailView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DetailView();
}

class _DetailView extends State<DetailView> {
  Map<String, dynamic> detail = <String, dynamic>{};
  var id;

  void getJSONDataFromID(String query) async {
    var url = 'http://127.0.0.1:8000/product/' + query;
    var response = await http.get(Uri.parse(url));
    setState(() {
      var dataFromJSON = json.decode(utf8.decode(response.bodyBytes));
      detail = dataFromJSON;
    });
  }

  @override
  void initState() {
    super.initState();

    // future that allows us to access context. function is called inside the future
    // otherwise it would be skipped and args would return null
    Future.delayed(Duration.zero, () {
      setState(() {
        id = ModalRoute.of(context)!.settings.arguments;
        getJSONDataFromID(id);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF20bca4),
      body: ListView(
        children: <Widget>[
          AppBar(elevation: 0),
          Container(
            width: double.infinity,
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 100),
                  width: double.infinity,
                  height: 1000,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: 80),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          detail['name'].toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text('Company# ' + detail['company'].toString()),
                        Text('Price# ' + detail['price'].toString()),
                        Text('Rate# ' +
                            (detail['avg_rate'] ?? 0.0).toStringAsFixed(2)),
                        Text('\n\nComments\n===================='),
                        if (detail['comments'] == null)
                          Text('댓글 없음')
                        else
                          for (var i in detail['comments'])
                            Text(i['user'] + ': ' + i['comment']),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Image.network(detail['image'].toString(),
                        width: 180, fit: BoxFit.contain),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
