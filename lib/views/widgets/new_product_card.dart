import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class NewProductCard extends StatelessWidget {
  Map<String, dynamic> data = <String, dynamic>{};
  int? idx;

  NewProductCard({required this.data, this.idx});

  @override
  Widget build(BuildContext context) {
    var f = NumberFormat('###,###,###,###');
    var left_margin = 15.0;
    if (idx == 0) left_margin = 20.0;
    var card = Container(
      margin: EdgeInsets.only(left: left_margin),
      child: Row(
        children: [
          // product image
          Container(
              margin: EdgeInsets.only(left: 10),
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.contain,
                      image: NetworkImage(data['image'] ?? '')))),

          // product informations
          Container(
              padding: EdgeInsets.only(left: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // product company, avg rate, num of comments
                  Row(
                    children: [
                      Text(
                        data['company'].toString() + ' · ',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.8),
                          fontSize: 12.0,
                        ),
                      ),
                      Text(
                        '★' + (data['avg_rate'] ?? 0.0).toString(),
                        style: TextStyle(
                          color: Color(0xFFFCAF00),
                          fontSize: 12.0,
                        ),
                      ),
                      Text(
                        ' (' + data['comment_count'].toString() + ')',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.8),
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),

                  // product name
                  SizedBox(
                    width: 130.0,
                    child: Text(
                      data['name'].toString(),
                      maxLines: 1,
                      overflow: TextOverflow.fade, //.ellipsis
                      softWrap: false,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),

                  // product price
                  SizedBox(
                    width: 130.0,
                    child: Text(
                      data['category'].toString() +
                          ' / ' +
                          f.format(data['price']) +
                          '원',
                      maxLines: 1,
                      overflow: TextOverflow.fade, //.ellipsis
                      softWrap: false,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ],
              )),
        ],
      ),
      decoration: BoxDecoration(
        color: Color(0xFFF9F9F9), // 0xFFF9F9F9
        borderRadius: BorderRadius.circular(8),
      ),
    );
    return card;
  }
}
