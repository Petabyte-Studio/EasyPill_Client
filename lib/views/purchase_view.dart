import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:group_button/group_button.dart';
import 'basket_view.dart';

class PurchaseView extends StatefulWidget {
  List<product>? productInfos;
  PurchaseView({List<product>? productInfos})
      : this.productInfos = productInfos ?? [];
  State<StatefulWidget> createState() => _PurchaseView();
}

class _PurchaseView extends State<PurchaseView> {
  String test = 'Before Add';
  String address = '주';
  List? data;
  var numberComma = NumberFormat('###,###,###,###');
  int totalPrice = 0;

  @override
  void initState() {
    super.initState();
    data = List.empty(growable: true);
    getJSONData();
    setTotalPrice();
  }

  void setTotalPrice() {
    for (int i = 0; i < widget.productInfos!.length; i++) {
      totalPrice += widget.productInfos![i].price;
    }
  }

  void getJSONData() async {
    String url;
    for (int i = 0; i < widget.productInfos!.length; i++) {
      url = 'http://49.247.147.204:8000/product?search=' +
          (widget.productInfos![i].id).toString() +
          '&search_fields=id';
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
        title: Text(
          '주문페이지',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFFFFFFFF),
        elevation: 0.5,
      ),
      body: Container(
          child: ListView(children: <Widget>[
        Container(
            margin: EdgeInsets.only(left: 20, top: 20),
            child: Text('주문상품 (' + widget.productInfos!.length.toString() + ')',
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
                              width: 200,
                              margin: EdgeInsets.only(left: 10),
                              child: Text(
                                data![index]['name'].toString(),
                                maxLines: 1,
                                overflow: TextOverflow.fade,
                                softWrap: false,
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
                              width: 200,
                              margin: EdgeInsets.only(left: 10),
                              child: Text(
                                data![index]['description'].toString(),
                                maxLines: 1,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 12),
                              )),
                          Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Text(
                                numberComma
                                        .format(
                                            widget.productInfos![index].price)
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
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20, left: 20),
            child: Text('배송지 정보',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                              color: Color(0xffff9500),
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
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20, left: 20),
            child: Text('결제수단',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Container(
              margin: EdgeInsets.all(20),
              child: GroupButton(
                mainGroupAlignment: MainGroupAlignment.spaceBetween,
                spacing: 20,
                isRadio: true,
                onSelected: (index, isSelected) => print(
                    '$index button is ${isSelected ? 'selected' : 'unselected'}'),
                buttons: [
                  "신용/체크카드",
                  "무통장입금",
                  "휴대폰 결제",
                ],
                selectedButton: 0,
                selectedTextStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
                unselectedTextStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
                selectedColor: Color(0xffff9500),
                unselectedColor: Colors.white,
                unselectedBorderColor: Color(0xffe7e7e7),
                borderRadius: BorderRadius.circular(5.0),
                selectedShadow: <BoxShadow>[
                  BoxShadow(color: Colors.transparent)
                ],
                unselectedShadow: <BoxShadow>[
                  BoxShadow(color: Colors.transparent)
                ],
              )),
        ]),
        Container(
            width: double.infinity,
            child: Divider(color: Color(0xffe7e7e7), thickness: 10.0)),
        Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Text('위 주문 내용을 확인했으며, 회원 본인은 결제에 동의합니다.',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Text('구매 조건 확인 및 결제진행 동의 내용 보기',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        decoration: TextDecoration.underline)),
              ),
            ]),
        Container(
            margin: EdgeInsets.fromLTRB(20, 20, 20, 5),
            child: ConstrainedBox(
                constraints: BoxConstraints.tightFor(height: 50),
                child: ElevatedButton(
                  child: Text(
                    "결제하기",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: do_nothing,
                  style: ElevatedButton.styleFrom(
                      primary: Color(0xFF20bca4), elevation: 0),
                ))),
      ])),
    );
  }
}

void do_nothing() {}
