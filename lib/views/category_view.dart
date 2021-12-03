import 'package:flutter/material.dart';
import './widgets/category_card_widget.dart';
import '../data/category.dart';

class CategoryView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CategoryView();
}

class _CategoryView extends State<CategoryView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '영양제 선택',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
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
      body: ListView(
        children: <Widget>[
          CategoryCard(
            korCategory: '전체보기',
            isAccent: true,
            padding: EdgeInsets.only(left: 16, right: 16, top: 15, bottom: 24),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemBuilder: (context, index) => CategoryCard(
                korCategory: Category.categoryList.keys.elementAt(index + 1),
                engCategory: Category.categoryList.values.elementAt(index + 1)),
            itemCount: Category.categoryList.length - 1,
          ),
        ],
      ),
    );
  }
}
