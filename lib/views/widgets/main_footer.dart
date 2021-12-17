import 'package:flutter/material.dart';

class MainFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: 77,
      color: Color(0xFFF8F9FA),
      child: GestureDetector(
        child: RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
            text: '페타바이트 이지필\n',
            style: TextStyle(
              fontSize: 10,
              color: Color(0xFFADB5BD),
            ),
            children: <TextSpan>[
              TextSpan(text: '서울특별시 동작구 상도로 369\n제휴문의: 010-7372-2994\n'),
              TextSpan(
                text: '이용약관',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline),
              ),
              TextSpan(text: ' 및 '),
              TextSpan(
                text: '개인정보 처리 방침',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline),
              ),
            ],
          ),
        ),
        onTap: () => Navigator.of(context).pushNamed('/setting'),
      ),
    );
  }
}
