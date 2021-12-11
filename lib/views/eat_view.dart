import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';

class EatView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EatView();
}

class _EatView extends State<EatView> {
  final List<String> dateList = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];

  DateTime _todayDate = DateTime.now();
  DateTime _calendarDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _calendarDate = DateTime(_todayDate.year, _todayDate.month, 1);
  }

  Widget calenderSelect({DateTime? selectedTime}) {
    return Container(
      width: double.infinity,
      height: 54,
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back_ios, color: const Color(0xFF1D1D1B)),
            iconSize: 12,
            onPressed: () => {
              setState(
                () {
                  _calendarDate =
                      DateTime(_calendarDate.year, _calendarDate.month - 1, 1);
                },
              ),
            },
          ),
          Text(
            selectedTime != null
                ? (selectedTime.year.toString() +
                    "년 " +
                    selectedTime.month.toString() +
                    "월")
                : "",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward_ios, color: const Color(0xFF1D1D1B)),
            iconSize: 12,
            onPressed: () => {
              setState(
                () {
                  _calendarDate = DateTime(_calendarDate.year,
                      _calendarDate.month + 1, _calendarDate.day);
                },
              ),
            },
          ),
        ],
      ),
    );
  }

  Widget heatMap({int? width, int? height, List<int>? input}) {
    int _date = 1;
    print(DateTime(_calendarDate.year, _calendarDate.month + 1, 0).day);
    DateTime.saturday;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 16, right: 16),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              for (String dateString in dateList)
                Text(
                  dateString,
                  style: const TextStyle(
                      color: Color(0xFF758EA1),
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
            ],
          ),
          const SizedBox(height: 16),
          for (int i = 0; i < (height ?? 7); i++)
            (_calendarDate.weekday != DateTime.sunday || i != 0)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      for (int j = 1; j < 8; j++)
                        ((i != 0 || j > _calendarDate.weekday) &&
                                (_date <=
                                    DateTime(_calendarDate.year,
                                            _calendarDate.month + 1, 0)
                                        .day))
                            ? Flexible(
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      (_date).toString(),
                                      style: const TextStyle(
                                        color: Color(0xFF8A8A8A),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    margin: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(11),
                                      color: input != null
                                          ? (input.contains(_date++)
                                              ? Color(0xFF6FCF97)
                                              : Color(0xFFF8F9FA))
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            : Flexible(
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(11),
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                    ],
                  )
                : const SizedBox(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '영양제 섭취이력',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
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
        child: Column(
          children: <Widget>[
            calenderSelect(selectedTime: _calendarDate),
            const SizedBox(height: 10),
            heatMap(width: 7, height: 6, input: [1, 5, 10, 21]),
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: ListView(
                  children: <Widget>[
                    eatInfoList(),
                  ],
                ),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF000000).withOpacity(0.1),
                      blurRadius: 26,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container eatInfoList({
    Map<String, int>? eatInfoMap,
    String? title,
    DateTime? eatTime,
  }) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 26,
                backgroundColor: Color(0xFF53B175).withOpacity(0.1),
                child: SvgPicture.asset('assets/images/medicine_fill.svg',
                    width: 28, height: 28),
              ),
              const SizedBox(width: 12),
              Text(
                '아침',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '오전 8시 30분',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
              const Spacer(),
              Text(
                '섭취 완료',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6FCF97),
                ),
              ),
            ],
          ),
          for (int i = 0; i < 3; i++)
            Padding(
              padding: const EdgeInsets.only(left: 64.0, bottom: 12),
              child: Row(
                children: [
                  Text(
                    '• ' + 'asdf',
                    style: TextStyle(fontSize: 12),
                  ),
                  const Spacer(),
                  Text('섭취 완료', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
