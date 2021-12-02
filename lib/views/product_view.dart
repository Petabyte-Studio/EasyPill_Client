import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/category.dart';

class ProductView extends StatefulWidget {
  State<StatefulWidget> createState() => _ProductView();
}

class _ProductView extends State<ProductView> {
  String test = 'Before Add';
  List? data;
  int sortMethod = 0;
  List<String> sortMethodList = ['name', 'avg_rate', 'created_at', 'price'];
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
        category +
        '&ordering=' +
        sortMethodList[sortMethod];
    var response = await http.get(Uri.parse(url));
    setState(() {
      var dataFromJSON = json.decode(utf8.decode(response.bodyBytes));
      data!.addAll(dataFromJSON);
    });
  }

  Widget sortChip(int index, String title) {
    return ChoiceChip(
      label: Text(
        title,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: sortMethod == index ? Color(0xFF6FCF97) : Color(0xFFADB5BD)),
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      selected: sortMethod == index,
      onSelected: (bool selected) {
        if (index != sortMethod) {
          setState(() {
            sortMethod = index;
            data = [];
            getJSONData(category);
          });
        }
      },
    );
  }

  Widget sortChipWrap() {
    return Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: EdgeInsets.only(left: 16, bottom: 12),
          child: Wrap(
            spacing: 12,
            children: <Widget>[
              sortChip(0, '이름순'),
              sortChip(1, '인기순'),
              sortChip(2, '최신순'),
              sortChip(3, '가격순'),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: <Widget>[
            Text(
              category ?? '로딩 중..',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              Category.categoryList[category] ?? 'Loading..',
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.4)),
            )
          ],
        ),
        bottom: PreferredSize(
          child: Container(
            color: const Color(0xFFF1F1F1),
            height: 0.7,
          ),
          preferredSize: const Size.fromHeight(0.7),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.shopping_cart, color: const Color(0xFF1D1D1B)),
              onPressed: () => {}),
        ],
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            sortChipWrap(),
            Expanded(
              child: data!.length == 0
                  ? Container(
                      child: const CircularProgressIndicator(),
                      alignment: Alignment.center,
                    )
                  : ListView.builder(
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          child: ListTile(
                            title: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Image.network(
                                        data![index]['image'].toString(),
                                        width: 48,
                                        fit: BoxFit.contain),
                                    Padding(
                                      padding: EdgeInsets.only(left: 19),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                data![index]['company']
                                                        .toString() +
                                                    ' • ',
                                                style: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(0.4),
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              Text(
                                                '★ ' +
                                                    (data![index]['avg_rate'] ??
                                                            0.0)
                                                        .toStringAsFixed(2),
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFFFCAF00),
                                                ),
                                              ),
                                              Text(
                                                (' (' +
                                                    data![index]
                                                            ['comment_count']
                                                        .toString() +
                                                    ')'),
                                                style: TextStyle(fontSize: 10),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8),
                                            child: Text(
                                              data![index]['name'].toString(),
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      data![index]['price'].toString() + '원',
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF515151),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const Divider(
                                    height: 20, color: Color(0xFFF1F1F1)),
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
          ],
        ),
      ),
    );
  }
}
