import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class PurchaseView extends StatefulWidget {
  State<StatefulWidget> createState() => _PurchaseView();
}

class _PurchaseView extends State<PurchaseView> {
  String test = 'Before Add';
  List? data;
  var numberComma = NumberFormat('###,###,###,###');
  Map<String, int> productInfo = {"KIRKLAND 비타민 C": 1, "숭실비타민": 2};
  int totalPrice = 240000;

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
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
        ListView.builder(
            physics: NeverScrollableScrollPhysics(),
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
                                data![index]['description'].toString(),
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 12),
                              )),
                          Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Text(
                                numberComma
                                        .format((data![index]['price'] *
                                            productInfo.values
                                                .elementAt(index)))
                                        .toString() +
                                    '원',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              )),
                        ]),
                  ],
                ),
                onTap: () {},
              );
            },
            itemCount: data!.length),
        Container(
            width: double.infinity,
            child: Divider(color: Color(0xffe7e7e7), thickness: 10.0)),
        Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 20, left: 20),
                  child: Text(
                    '상품금액',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, right: 20),
                  child: Text(
                    numberComma.format(totalPrice).toString() + '원',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 20, left: 20),
                  child: Text(
                    '배송비',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, right: 20),
                  child: Text(
                    '무료',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            Container(
                width: double.infinity,
                margin: EdgeInsets.all(20),
                child: Divider(color: Color(0xffe7e7e7), thickness: 1.5)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Text(
                    '총 결제 금액',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 20),
                  child: Text(
                    numberComma.format(totalPrice).toString() + '원',
                    style: TextStyle(
                        color: Color(0xFF20bca4),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            )
          ],
        ),
        Container(
            margin: EdgeInsets.only(top: 20),
            width: double.infinity,
            child: Divider(color: Color(0xffe7e7e7), thickness: 10.0)),
        Column(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 20, left: 20),
                child: Text('배송지 정보',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 10, bottom: 20, left: 20, right: 20),
              child: Divider(color: Color(0xffe7e7e7), thickness: 1.5)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 20),
                child: Text('수령인',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              Flexible(
                  child: Container(
                      height: 50,
                      margin: EdgeInsets.only(left: 25, right: 20),
                      child: TextField(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xffe7e7e7), width: 1.0)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFF20bca4), width: 1.0)),
                          hintText: '이름을 입력해 주세요.',
                          hintStyle: TextStyle(color: Colors.grey),
                          isDense: true,
                        ),
                      ))),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 20),
                child: Text('휴대폰',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              Flexible(
                  child: Container(
                      height: 50,
                      margin: EdgeInsets.only(left: 25, right: 20),
                      child: TextField(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xffe7e7e7), width: 1.0)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFF20bca4), width: 1.0)),
                          hintText: '휴대폰 번호를 입력해 주세요.',
                          hintStyle: TextStyle(color: Colors.grey),
                          isDense: true,
                        ),
                      ))),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 20),
                child: Text('우편번호',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              Flexible(
                  child: Container(
                      height: 50,
                      margin: EdgeInsets.only(left: 11),
                      child: TextField(
                        enableInteractiveSelection: false,
                        enabled: false,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xfff0f0f0),
                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xffe7e7e7), width: 1.0)),
                          isDense: true,
                        ),
                      ))),
              Container(
                  margin: EdgeInsets.only(left: 10, right: 20),
                  child: ConstrainedBox(
                      constraints:
                          BoxConstraints.tightFor(height: 50, width: 150),
                      child: ElevatedButton(
                        child: Text(
                          "우편번호 찾기",
                          style: TextStyle(
                              color: Color(0xfff19938),
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: do_nothing,
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xfffdf4e8), elevation: 0),
                      )))
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 20),
                child: Text('주소지',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              Flexible(
                  child: Container(
                      height: 50,
                      margin: EdgeInsets.only(left: 25, right: 20),
                      child: TextField(
                        enableInteractiveSelection: false,
                        enabled: false,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xfff0f0f0),
                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xffe7e7e7), width: 1.0)),
                          isDense: true,
                        ),
                      ))),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 20),
                child: Text('상세주소',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              Flexible(
                  child: Container(
                      height: 50,
                      margin: EdgeInsets.only(left: 11, right: 20),
                      child: TextField(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xffe7e7e7), width: 1.0)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFF20bca4), width: 1.0)),
                          hintText: '상세 주소를 입력해 주세요.',
                          hintStyle: TextStyle(color: Colors.grey),
                          isDense: true,
                        ),
                      ))),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 20),
                child: Text('배송메모',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              Flexible(
                  child: Container(
                      height: 50,
                      margin: EdgeInsets.only(left: 11, right: 20),
                      child: TextField(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xffe7e7e7), width: 1.0)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFF20bca4), width: 1.0)),
                          hintText: '배송 메모를 입력해 주세요.',
                          hintStyle: TextStyle(color: Colors.grey),
                          isDense: true,
                        ),
                      ))),
            ],
          ),
        ]),
        Container(
            margin: EdgeInsets.only(top: 20),
            width: double.infinity,
            child: Divider(color: Color(0xffe7e7e7), thickness: 10.0)),
      ])),
    );
  }
}

void do_nothing() {}
