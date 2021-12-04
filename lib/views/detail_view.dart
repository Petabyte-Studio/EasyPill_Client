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

  Widget gridObject({
    String? title,
    double? current,
    double? max,
    Color? textColor,
    Color? backgroundColor,
  }) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(
                child: Text(
                  title ?? "로딩 중..",
                  style: TextStyle(
                    color: textColor ?? Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        width: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(60),
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
      ),
    );
  }

  Widget horizontalGrid({List<Widget>? children}) {
    return Container(
      width: double.infinity,
      height: 160,
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        children: <Widget>[
          children![0],
          const Spacer(),
          children[1],
        ],
      ),
    );
  }

  Widget listComponent({String? title, String? value, TextStyle? subStyle}) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 12),
      child: Row(
        children: <Widget>[
          Text(
            title ?? '',
            style: const TextStyle(
              color: Color(0xFF6FCF97),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const Spacer(),
          Text(
            value ?? '',
            style: subStyle ??
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          )
        ],
      ),
    );
  }

  Widget ingredientContainer({
    List<Widget>? children,
    String? title,
  }) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: <Widget>[
                Text(
                  title ?? '',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Colors.black.withOpacity(0.7),
                ),
              ],
            ),
          ),
          for (Widget card in children!) card,
        ],
      ),
    );
  }

  Widget ingredientCard(
      {String? title,
      int? current,
      int? max,
      Color? startColor,
      Color? progressColor}) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title ?? '',
              style: const TextStyle(
                color: Color(0xFF858597),
                fontSize: 12,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  (current ?? 0).toString() + 'mg',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '/' + (max ?? 0).toString() + 'mg',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF858597),
                  ),
                ),
              ],
            ),
            Container(
              child: FractionallySizedBox(
                widthFactor: (current! / max!),
                heightFactor: 1,
                alignment: Alignment.centerLeft,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        (startColor ?? Colors.white),
                        (progressColor ?? Colors.black)
                      ],
                    ),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              margin: EdgeInsets.only(top: 10),
              width: double.infinity,
              height: 6.04,
              decoration: BoxDecoration(
                color: Color(0xFFF4F3FD),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ],
        ),
      ),
      width: double.infinity,
      height: 96,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFB8B8D2).withOpacity(0.2),
            blurRadius: 12,
          )
        ],
      ),
    );
  }

  Widget descriptionWidget() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '제품 설명',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget commentContainer({
    List<dynamic>? comments,
    String? title,
  }) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: <Widget>[
                Text(
                  title ?? '',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Colors.black.withOpacity(0.7),
                ),
              ],
            ),
          ),
          comments!.isNotEmpty
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
                                      comments[index]['user'].toString(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black.withOpacity(0.6),
                                      ),
                                    ),
                                    Text(
                                      '★' + comments[index]['rate'].toString(),
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
                                comments[index]['created_at']
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
                              comments[index]['comment'].toString(),
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    margin: EdgeInsets.only(bottom: 16),
                    width: double.infinity,
                    height: 130,
                    decoration: BoxDecoration(
                      color: Color(0xFFF9F9F9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  itemCount: comments.length < 5 ? comments.length : 5,
                )
              : Text(
                  '작성된 리뷰가 없습니다.',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6FCF97),
                  ),
                ),
          // ListView(
          //   shrinkWrap: true,
          //   physics: const ScrollPhysics(),
          //   // scrollDirection: Axis.horizontal,
          //   children: <Widget>[
          //     for (var comment in comments!)
          //       Container(
          //         margin: EdgeInsets.only(bottom: 16),
          //         width: double.infinity,
          //         height: 60,
          //         decoration: BoxDecoration(
          //           color: Color(0xFFF9F9F9),
          //           borderRadius: BorderRadius.circular(8),
          //         ),
          //       )
          //     // Text(comment['comment'].toString()),
          //   ],
          // ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Color(0xFF6FCF97),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Color(0x00000000),
        iconTheme: IconThemeData(
          color: Colors.black.withOpacity(0.8),
        ),
      ),
      body: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              Container(
                width: double.infinity,
                child: Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 100),
                      width: double.infinity,
                      decoration: const BoxDecoration(
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
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8, bottom: 12),
                              child: Text(
                                detail['company'].toString(),
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.5)),
                              ),
                            ),
                            listComponent(
                              title: '1회 섭취',
                              value: '1000mg',
                            ),
                            listComponent(
                              title: '순위',
                              value: '1000mg',
                            ),
                            listComponent(
                              title: '평점',
                              value: (detail['avg_rate'] ?? 0.0)
                                      .toStringAsFixed(1) +
                                  ' ' +
                                  ('★' *
                                      (detail['avg_rate'] != null
                                          ? detail['avg_rate'].round()
                                          : 1)),
                              subStyle: const TextStyle(
                                color: Color(0xFFFCAF00),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            listComponent(
                              title: '정가',
                              value: detail['price'].toString() + '원',
                            ),
                            const SizedBox(height: 49),
                            ingredientContainer(
                              title: '주요성분',
                              children: [
                                ingredientCard(
                                  title: '안전 성분',
                                  current: 800,
                                  max: 1000,
                                  startColor:
                                      const Color(0xFF398A80).withOpacity(0.3),
                                  progressColor: const Color(0xFF398A80),
                                ),
                                ingredientCard(
                                  title: '위험 성분',
                                  current: 505,
                                  max: 1000,
                                  progressColor: const Color(0xFFFF5106),
                                ),
                                ingredientCard(
                                  title: '안전 성분',
                                  current: 30,
                                  max: 1000,
                                  startColor:
                                      const Color(0xFF3D5CFF).withOpacity(0.5),
                                  progressColor: const Color(0xFF3D5CFF),
                                ),
                              ],
                            ),
                            const SizedBox(height: 38),
                            horizontalGrid(
                              children: <Widget>[
                                gridObject(
                                  backgroundColor: Color(0xFFFFDFDF),
                                  title: '구매자 중\n90%가\n만족했어요!',
                                  textColor: Color(0xFFAE4343),
                                ),
                                gridObject(
                                  backgroundColor: Color(0xFFF0F5FF),
                                  title: '별점이 높은\n제품\n9.2 / 10',
                                  textColor: Color(0xFF437BAE),
                                ),
                              ],
                            ),
                            const SizedBox(height: 50),
                            descriptionWidget(),
                            const SizedBox(height: 50),
                            commentContainer(
                              title: '댓글',
                              comments: detail['comments'],
                            ),
                            SizedBox(height: 100),
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
          Positioned(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const <Widget>[
                      Text(
                        '장바구니에 추가하기',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                  width: double.infinity,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Color(0xFF6FCF97),
                  ),
                ),
                onTap: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Text('Price# ' + detail['price'].toString()),
// Text('Rate# ' +
//     (detail['avg_rate'] ?? 0.0).toStringAsFixed(2)),
// Text('\n\nComments\n===================='),
// if (detail['comments'] == null)
//   Text('댓글 없음')
// else
//   for (var i in detail['comments'])
//     Text(i['user'] + ': ' + i['comment']),
