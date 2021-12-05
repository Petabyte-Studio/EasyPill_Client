import 'package:flutter/material.dart';

class FunnyView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FunnyView();
}

class _FunnyView extends State<FunnyView> {
  Widget macButtonList({int? itemCount, double? radius, List<Color>? colors}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        children: <Widget>[
          for (int i = 0; i < (itemCount ?? 0); i++)
            macButton(radius: radius, color: colors![i]),
        ],
      ),
    );
  }

  Widget macButton({double? radius, Color? color}) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      width: radius ?? 12,
      height: radius ?? 12,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular((radius ?? 12) / 2.0)),
    );
  }

  Widget heatMap({int? width, int? height, Map<int, int>? input}) {
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          for (int i = 0; i < (height ?? 7); i++)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                for (int j = 0; j < (width ?? 30); j++)
                  Container(
                    margin: EdgeInsets.all(2),
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: input != null
                          ? (input[i] == j ? Color(0xFF6FCF97) : Colors.white)
                          : Colors.white,
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              macButtonList(
                itemCount: 3,
                radius: 16,
                colors: [
                  Color(0xFFFF5F57),
                  Color(0xFFFEBC2E),
                  Color(0xFF26C841)
                ],
              ),
              Flexible(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 48,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '김승환',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 60),
                      heatMap(
                        width: 7,
                        input: {
                          1: 3,
                          2: 5,
                          4: 1,
                        },
                      ),
                    ],
                  ),
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ],
          ),
        ),
        margin: EdgeInsets.only(left: 32, right: 32, top: 64, bottom: 64),
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xFF2D2733),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFB8B8D2).withOpacity(0.8),
              blurRadius: 12,
            ),
          ],
        ),
      ),
    );
  }
}
