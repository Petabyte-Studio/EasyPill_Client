import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RecommendCard extends StatelessWidget {
  Map<String, dynamic> data = <String, dynamic>{};
  int? idx;

  RecommendCard({ required this.data, this.idx });

  @override
  Widget build(BuildContext context) {
    var left_margin = 15.0;
    if(idx == 0) left_margin = 20.0;
    var card = Container(
      margin: EdgeInsets.only(left: left_margin),
      child: Column(
        children: [
        Container(
          child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      // product image
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(data['image'] ?? '')
                          )
                        )
                      ),
                      // product info
                      Container(
                        padding: EdgeInsets.only(left: 8, right: 8, top: 15),
                        child: Column(
                          children: [
                            // best product badge
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 40.0,
                                  height: 15.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color(0xFFFF4848),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 1, bottom: 1),
                                  child: Text(
                                    "BEST",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold, 
                                      fontSize: 10.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),

                            // product name
                            Text(
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
                            SizedBox(height: 5),

                            // product company and avg rate with num of comments
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
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
