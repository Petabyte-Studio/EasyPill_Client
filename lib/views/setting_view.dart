import 'package:flutter/material.dart';

class SettingView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingView();
}

class _SettingView extends State<SettingView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Setting'),
      ),
    );
  }
}
