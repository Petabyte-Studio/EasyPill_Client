import 'package:easypill_client/views/purchase_view.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class BasketView extends StatefulWidget {
  State<StatefulWidget> createState() => _BasketView();
}

class product {
  int id = 0;
  String name = "";
  bool checkBox = true;
  int count = 0;
  int price = 0;
  bool isDisabled = false;

  product(int id, String name, int count, int price) {
    this.id = id;
    this.name = name;
    this.count = count;
    this.price = price;
  }
}

class _BasketView extends State<BasketView> {
  List? data;
  var numberComma = NumberFormat('###,###,###,###');
  Map<String, int> productInfo = {"36": 1, "25": 1, "23": 1};
  List<product> productInfos = [];
  List<product> tempProducts = [];
  product? tempProduct;
  int totalPrice = 0;

  @override
  void initState() {
    super.initState();
    data = List.empty(growable: true);
    getJSONData();
  }

  void getJSONData() async {
    String url;
    for (int i = 0; i < productInfo.length; i++) {
      url = 'http://49.247.147.204:8000/product?search=' +
          productInfo.keys.elementAt(i).toString() +
          '&search_fields=id';
      var response = await http.get(Uri.parse(url));
      setState(() {
        var dataFromJSON = json.decode(utf8.decode(response.bodyBytes));
        data!.addAll(dataFromJSON);
      });
    }
    makeProductObject();
  }

  void makeProductObject() {
    for (int i = 0; i < productInfo.length; i++) {
      tempProduct = new product(
          data![i]['id'] ?? 0,
          data![i]['name'],
          productInfo[data![i]['id'].toString()] ?? 1,
          int.parse(data![i]['price'].toString()) *
              productInfo.values.elementAt(i));
      productInfos.add(tempProduct!);
      totalPrice += productInfos[i].price;
    }
  }

  void deleteInListIfNotChecked() {
    tempProducts = List.from(productInfos);
    for (int i = 0; i < productInfos.length; i++) {
      tempProducts
          .removeWhere((tempProducts) => tempProducts.checkBox == false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '???????????????',
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
            margin: EdgeInsets.only(left: 20, top: 20, bottom: 20),
            child: Text('???????????? ?????? ?????? (' + productInfo.length.toString() + ')',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
        ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return GestureDetector(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Checkbox(
                                  activeColor: Color(0xFF20bca4),
                                  value: productInfos.length >= 1
                                      ? productInfos[index].checkBox
                                      : false,
                                  tristate: true,
                                  onChanged: (value) {
                                    if (productInfos[index].checkBox == true) {
                                      setState(() {
                                        productInfos[index].checkBox = false;
                                        totalPrice -= int.parse((data![index]
                                                    ['price'] *
                                                productInfos[index].count)
                                            .toString());
                                      });
                                    } else {
                                      setState(() {
                                        productInfos[index].checkBox = true;
                                        totalPrice += int.parse((data![index]
                                                    ['price'] *
                                                productInfos[index].count)
                                            .toString());
                                      });
                                    }
                                  }),
                            ),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      width: 200,
                                      margin: EdgeInsets.only(left: 10),
                                      child: Text(
                                        data![index]['name'].toString(),
                                        textAlign: TextAlign.left,
                                        maxLines: 1,
                                        overflow: TextOverflow.fade,
                                        softWrap: false,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
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
                                      child: SizedBox(
                                        width: 230,
                                        child: Text(
                                          data![index]['description']
                                              .toString(),
                                          maxLines: 1,
                                          overflow: TextOverflow.fade,
                                          softWrap: false,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      )),
                                  Container(
                                      margin: EdgeInsets.only(left: 10),
                                      child: Text(
                                        numberComma
                                                .format(productInfos.length >= 1
                                                    ? productInfos[index].price
                                                    : 0)
                                                .toString() +
                                            '???',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      )),
                                  Row(
                                    children: <Widget>[
                                      (productInfos.length >= 1
                                                  ? productInfos[index]
                                                      .isDisabled
                                                  : true) ==
                                              true
                                          ? IconButton(
                                              icon: Icon(Icons.remove),
                                              onPressed: () => do_nothing())
                                          : IconButton(
                                              icon: Icon(Icons.remove),
                                              onPressed: () => setState(() {
                                                productInfos[index].count--;
                                                if (productInfos[index].count <=
                                                    0)
                                                  productInfos[index]
                                                      .isDisabled = true;
                                                if (productInfos[index]
                                                        .checkBox ==
                                                    true) {
                                                  totalPrice -= int.parse(
                                                      data![index]['price']
                                                          .toString());
                                                }
                                                productInfos[index].price =
                                                    data![index]['price'] *
                                                        productInfos[index]
                                                            .count;
                                              }),
                                            ),
                                      Text(productInfos.length >= 1
                                          ? productInfos[index].count.toString()
                                          : ''),
                                      IconButton(
                                          icon: Icon(Icons.add),
                                          onPressed: () => setState(() {
                                                productInfos[index].count++;
                                                productInfos[index].isDisabled =
                                                    false;
                                                if (productInfos[index]
                                                        .checkBox ==
                                                    true) {
                                                  totalPrice += int.parse(
                                                      data![index]['price']
                                                          .toString());
                                                }
                                                productInfos[index].price =
                                                    data![index]['price'] *
                                                        productInfos[index]
                                                            .count;
                                              })),
                                    ],
                                  ),
                                ]),
                          ],
                        ),
                        Container(
                            margin: EdgeInsets.only(right: 20),
                            child: Image(
                              image: NetworkImage(
                                  data![index]['image'].toString()),
                              height: 90,
                              width: 90,
                            )),
                      ],
                    ),
                    if (index != productInfo.length - 1)
                      Container(
                          width: double.infinity,
                          margin: EdgeInsets.all(20),
                          child: Divider(
                              color: Color(0xffe7e7e7), thickness: 1.5)),
                  ],
                ),
                onTap: () {},
              );
            },
            itemCount: data!.length),
        Container(
            margin: EdgeInsets.only(top: 20),
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
                    '????????????',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, right: 20),
                  child: Text(
                    numberComma.format(totalPrice).toString() + '???',
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
                    '?????????',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, right: 20),
                  child: Text(
                    '??????',
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
                    '??? ?????? ??????',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 20),
                  child: Text(
                    numberComma.format(totalPrice).toString() + '???',
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
      ])),
      bottomNavigationBar: Stack(
        alignment: FractionalOffset(.5, 1.0),
        children: [
          Container(
              height: 60,
              color: Color(0xFF41A063),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width: 80,
                      margin: EdgeInsets.only(left: 30, right: 30),
                      child: Text(numberComma.format(totalPrice).toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold))),
                  Flexible(
                    child: Container(
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                minimumSize: Size.fromHeight(60),
                                elevation: 0,
                                primary: Color(0xFF6FCF97),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                )),
                            onPressed: () => {
                                  deleteInListIfNotChecked(),
                                  if (tempProducts.length != 0)
                                    {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PurchaseView(
                                              productInfos: tempProducts,
                                            ),
                                          ))
                                    }
                                  else
                                    {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content:
                                                  Text("?????? ????????? ????????? ????????? ?????????."))),
                                    },
                                },
                            child: Text('????????????',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)))),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
