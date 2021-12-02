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
      body: Container(
        child: ListView.builder(
          itemBuilder: (context, index) => CategoryCard(
              Category.categoryList.keys.elementAt(index),
              Category.categoryList.values.elementAt(index)),
          itemCount: Category.categoryList.length,
        ),
      ),
    );
  }
}
