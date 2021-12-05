import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CommentView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CommentView();
}

class _CommentView extends State<CommentView> {
  List? comments;
  var id;

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

  void getJSONDataFromID(String query) async {
    var url = 'http://192.168.0.103:8000/product/' + query;
    var response = await http.get(Uri.parse(url));
    setState(() {
      var dataFromJSON = json.decode(utf8.decode(response.bodyBytes));
      comments = dataFromJSON['comments'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          '모든 댓글',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
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
      body: (comments != null)
          ? ListView.builder(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemBuilder: (context, index) => Container(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  comments![index]['user'].toString(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black.withOpacity(0.6),
                                  ),
                                ),
                                Text(
                                  '★' *
                                          (comments![index]['rate'] <= 5
                                              ? comments![index]['rate']
                                              : 5) +
                                      comments![index]['rate'].toString(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFCAF00),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Text(
                            comments![index]['created_at']
                                .toString()
                                .substring(0, 10),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black.withOpacity(0.6),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 12),
                      Flexible(
                        child: Text(
                          comments![index]['comment'].toString(),
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                margin: EdgeInsets.only(bottom: 8),
                width: double.infinity,
                height: 130,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              itemCount: comments!.length,
            )
          : Text('로딩 중..'),
    );
  }
}
