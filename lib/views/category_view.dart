import 'package:flutter/material.dart';
import './widgets/category_card_widget.dart';

class CategoryView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CategoryView();
}

class _CategoryView extends State<CategoryView> {
  Map<String, String> categoryList = {
    '비타민C': 'Vitamin-C',
    '비타민B': 'Vitamin-B',
    '비타민D': 'Vitamin-D',
    '멀티비타민': 'Multi-Vitamin',
    '아르기닌': 'L-arginine',
    '홍삼': 'Red ginseng',
    '프로폴리스': 'Propolis',
    '기타': 'Extras',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('영양제 선택'),
        bottom: PreferredSize(
          child: Container(
            color: const Color(0xFFF1F1F1),
            height: 0.7,
          ),
          preferredSize: const Size.fromHeight(0.7),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        child: ListView.builder(
          itemBuilder: (context, index) => CategoryCard(
              categoryList.keys.elementAt(index),
              categoryList.values.elementAt(index)),
          itemCount: categoryList.length,
        ),
      ),
    );
  }
}
