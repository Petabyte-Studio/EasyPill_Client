import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:badges/badges.dart';
import 'dart:convert';
import '../data/category.dart';

class ProductListView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProductListView();
}

class _ProductListView extends State<ProductListView> {
  String test = 'Before Add';
  List? data;
  int sortMethod = 0;
  int basketCount = 0;
  List<String> sortMethodList = [
    'name',
    '-comment_count',
    '-created_at',
    'price',
    '-avg_rate',
  ];
  var category;

  @override
  void initState() {
    super.initState();
    data = List.empty(growable: true);
    Future.delayed(Duration.zero, () {
      setState(() {
        category = ModalRoute.of(context)!.settings.arguments;
        if (category[0] == '>') {
          sortMethod = int.parse(category[1]);
          category = category.substring(2);
        }
        getJSONData(category == '전체보기' ? '' : category);
      });
    });
  }

  void getJSONData(var category) async {
    var url =
        'http://49.247.147.204:8000/product/?search_fields=category&search=' +
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
      pressElevation: 0,
      selectedColor: const Color(0xFF6FCF97).withOpacity(0.1),
      selected: sortMethod == index,
      onSelected: (bool selected) {
        if (index != sortMethod) {
          setState(() {
            sortMethod = index;
            data = [];
            getJSONData(category == '전체보기' ? '' : category);
          });
        }
      },
    );
  }

  Widget sortChipWrap() {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 16),
            child: Wrap(
              spacing: 12,
              children: <Widget>[
                sortChip(0, '이름순'),
                sortChip(1, '인기순'),
                sortChip(2, '최신순'),
                sortChip(3, '가격순'),
                sortChip(4, '평점순'),
              ],
            ),
          ),
        ),
      ],
    );
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
        centerTitle: true,
        bottom: PreferredSize(
          child: Container(
            color: const Color(0xFFF1F1F1),
            height: 0.7,
          ),
          preferredSize: const Size.fromHeight(0.7),
        ),
        actions: <Widget>[
          Badge(
            badgeContent: Text(
              basketCount.toString(),
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart, color: const Color(0xFF1D1D1B)),
              // onPressed: () => {setState(() => basketCount++)},
              onPressed: () => Navigator.of(context).pushNamed('/basket'),
            ),
            showBadge: basketCount > 0,
            elevation: 0,
            badgeColor: Color(0xFFFF9500),
            ignorePointer: true,
            position: BadgePosition.topEnd(top: 5, end: 5),
          ),
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
                  : ListView.separated(
                      itemBuilder: (context, index) {
                        return InkWell(
                          splashFactory: NoSplash.splashFactory,
                          child: Column(
                            children: [
                              ListTile(
                                title: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                                        (data![index][
                                                                    'avg_rate'] ??
                                                                0.0)
                                                            .toStringAsFixed(2),
                                                    style: const TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0xFFFCAF00),
                                                    ),
                                                  ),
                                                  Text(
                                                    (' (' +
                                                        data![index][
                                                                'comment_count']
                                                            .toString() +
                                                        ')'),
                                                    style:
                                                        TextStyle(fontSize: 10),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                width: 200,
                                                padding: const EdgeInsets.only(
                                                    top: 8),
                                                child: Text(
                                                  data![index]['name']
                                                      .toString(),
                                                  overflow: TextOverflow.fade,
                                                  maxLines: 1,
                                                  softWrap: false,
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          data![index]['price'].toString() +
                                              '원',
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF515151),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                '/category/product/detail',
                                arguments: data![index]['id'].toString());
                          },
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Divider(
                            height: 10, color: Color(0xFFF1F1F1));
                      },
                      itemCount: data!.length),
            ),
          ],
        ),
      ),
    );
  }
}
