import '../../data/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CategoryGrid extends StatelessWidget {
  String? category1 = Category.categoryList.keys.elementAt(1);
  String? category2 = Category.categoryList.keys.elementAt(2);
  String? category3 = Category.categoryList.keys.elementAt(4);
  String? category4 = Category.categoryList.keys.elementAt(6);
  String? category5 = Category.categoryList.keys.elementAt(3);
  String? category6 = Category.categoryList.keys.elementAt(5);
  String? category7 = Category.categoryList.keys.elementAt(7);
  String? engCategory;
  EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: <Widget>[
                Text(
                  "카테고리로 검색",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF212529),
                  ),
                ),
                const Spacer(),
                const Icon(Icons.arrow_forward_ios, size: 15),
              ],
            ),
          ),
          onTap: () {
            Navigator.of(context).pushNamed('/category');
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Card(
                    elevation: 0,
                    color: Color(0xFFF8F9FA),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0)),
                    child: InkWell(
                      splashFactory: NoSplash.splashFactory,
                      borderRadius: BorderRadius.circular(16.0),
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              child: SvgPicture.asset(
                                "assets/images/TopStar1.svg",
                                allowDrawingOutsideViewBox: true,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              child: Text(
                                category1.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed('/category/product',
                            arguments: category1);
                      },
                    )),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 00, 20, 0),
                child: Card(
                    elevation: 0,
                    color: Color(0xFFF8F9FA),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0)),
                    child: InkWell(
                      splashFactory: NoSplash.splashFactory,
                      borderRadius: BorderRadius.circular(16.0),
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              child: SvgPicture.asset(
                                "assets/images/TopStar2.svg",
                                allowDrawingOutsideViewBox: true,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              child: Text(
                                category2.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed('/category/product',
                            arguments: category2);
                      },
                    )),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Card(
                    elevation: 0,
                    color: Color(0xFFF8F9FA),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0)),
                    child: InkWell(
                      splashFactory: NoSplash.splashFactory,
                      borderRadius: BorderRadius.circular(16.0),
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              child: SvgPicture.asset(
                                "assets/images/TopStar3.svg",
                                allowDrawingOutsideViewBox: true,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              child: Text(
                                category3.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed('/category/product',
                            arguments: category3);
                      },
                    )),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: Card(
                    elevation: 0,
                    color: Color(0xFFF8F9FA),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0)),
                    child: InkWell(
                      splashFactory: NoSplash.splashFactory,
                      borderRadius: BorderRadius.circular(16.0),
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              child: SvgPicture.asset(
                                "assets/images/TopStar4.svg",
                                allowDrawingOutsideViewBox: true,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              child: Text(
                                category4.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed('/category/product',
                            arguments: category4);
                      },
                    )),
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Card(
                    elevation: 0,
                    color: Color(0xFFF8F9FA),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0)),
                    child: InkWell(
                      splashFactory: NoSplash.splashFactory,
                      borderRadius: BorderRadius.circular(16.0),
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            category5.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed('/category/product',
                            arguments: category5);
                      },
                    )),
              ),
              Expanded(
                child: Card(
                    elevation: 0,
                    color: Color(0xFFF8F9FA),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0)),
                    child: InkWell(
                      splashFactory: NoSplash.splashFactory,
                      borderRadius: BorderRadius.circular(16.0),
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            category6.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed('/category/product',
                            arguments: category6);
                      },
                    )),
              ),
              Expanded(
                child: Card(
                    elevation: 0,
                    color: Color(0xFFF8F9FA),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0)),
                    child: InkWell(
                      splashFactory: NoSplash.splashFactory,
                      borderRadius: BorderRadius.circular(16.0),
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            category7.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed('/category/product',
                            arguments: category7);
                      },
                    )),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
