import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CategoryCard extends StatelessWidget {
  String? korCategory;
  String? engCategory;
  bool isAccent = false;
  EdgeInsets? padding;

  CategoryCard(
      {this.padding,
      this.korCategory,
      this.engCategory,
      this.isAccent = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: padding ??
          const EdgeInsets.only(left: 16, right: 16, top: 6, bottom: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      color: isAccent ? Color(0xFF6FCF97).withOpacity(0.1) : Color(0xFFF8F9FA),
      elevation: 0,
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        borderRadius: BorderRadius.circular(16.0),
        child: Container(
          alignment: Alignment.centerLeft,
          width: double.infinity,
          height: 63,
          margin: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: <Widget>[
              Text(
                korCategory ?? '로딩 중..',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isAccent ? Color(0xFF6FCF97) : Colors.black),
              ),
              const SizedBox(width: 10),
              engCategory != null
                  ? Text(
                      engCategory ?? 'Loading..',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color:
                              isAccent ? Color(0xFF6FCF97) : Color(0xFF959596)),
                    )
                  : Text(''),
              const Spacer(),
              Icon(Icons.arrow_forward_ios,
                  size: 15,
                  color: isAccent ? Color(0xFF6FCF97) : Color(0xFF1D1D1B)),
            ],
          ),
        ),
        onTap: () {
          Navigator.of(context)
              .pushNamed('/category/product', arguments: korCategory);
        },
      ),
    );
  }
}
