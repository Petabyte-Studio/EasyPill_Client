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
      appBar: AppBar(title: Text('Detail Content')),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('ID# ' + (id ?? "Waiting")),
            Text('Name# ' + detail['name'].toString()),
            Text('Company# ' + detail['company'].toString()),
            Text('Price# ' + detail['price'].toString()),
            Text('Rate# ' + (detail['avg_rate'] ?? 0.0).toStringAsFixed(2)),
            Text('\n\nComments\n===================='),
            if (detail['comments'] == null)
              Text('댓글 없음')
            else
              for (var i in detail['comments'])
                Text(i['user'] + ': ' + i['comment']),
          ],
        ),
      ),
    );
  }
}
