import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CategoryCard extends StatelessWidget {
  String? _korCategory;
  String? _engCategory;

  CategoryCard(this._korCategory, this._engCategory);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        margin: const EdgeInsets.only(left: 16, right: 16, top: 6, bottom: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        color: Color(0xFFF8F9FA),
        elevation: 0,
        child: Container(
          alignment: Alignment.centerLeft,
          width: double.infinity,
          height: 63,
          margin: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: <Widget>[
              Text(
                _korCategory ?? '로딩 중..',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 10),
              Text(
                _engCategory ?? 'Loading..',
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF959596)),
              ),
              const Spacer(),
              SvgPicture.asset('assets/images/rightArrow.svg',
                  width: 13, height: 13, color: Color(0xFF123123)),
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.of(context)
            .pushNamed('/category/product', arguments: _korCategory);
      },
    );
  }
}
