import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:sqflite/sqflite.dart';

class EatView extends StatefulWidget {
  final Future<Database> db;
  EatView(this.db);

  @override
  State<StatefulWidget> createState() => _EatView();
}

class _EatView extends State<EatView> {
  final List<String> dateList = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];

  DateTime _calendarDate =
      DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime _selectedDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

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

  Widget heatMap({int? width, int? height, Map<DateTime, int>? input}) {
    int _date = 1;

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
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: InkWell(
                                      splashFactory: NoSplash.splashFactory,
                                      borderRadius: BorderRadius.circular(11.0),
                                      child: Ink(
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            (_date).toString(),
                                            style: const TextStyle(
                                              color: Color(0xFF8A8A8A),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(11),
                                          border: _selectedDate ==
                                                  DateTime(
                                                      _calendarDate.year,
                                                      _calendarDate.month,
                                                      _date)
                                              ? Border.all(
                                                  color: Color(0xFF53B175),
                                                  width: 3,
                                                )
                                              : null,
                                          color: input != null
                                              ? (input[DateTime(
                                                          _calendarDate.year,
                                                          _calendarDate.month,
                                                          _date++)] !=
                                                      null
                                                  ? Color(0xFF6FCF97)
                                                      .withOpacity(0.3 *
                                                          input[DateTime(
                                                              _calendarDate
                                                                  .year,
                                                              _calendarDate
                                                                  .month,
                                                              _date - 1)]!)
                                                  : Color(0xFFF8F9FA))
                                              : Colors.white,
                                        ),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          _selectedDate = DateTime(
                                              _calendarDate.year,
                                              _calendarDate.month,
                                              i * 7 +
                                                  j -
                                                  _calendarDate.weekday);
                                        });
                                      },
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

  Container eatInfoList({
    @required Map<String, bool>? eatInfoMap,
    @required String? title,
    @required int? hours,
    @required int? minutes,
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
                title ?? '',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                (hours! >= 12 && hours < 24 ? '오후 ' : '오전 ') +
                    (hours == 12 ? 12 : (hours % 12)).toString() +
                    '시 ' +
                    minutes.toString() +
                    '분',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
              const Spacer(),
              Text(
                eatInfoMap!.containsValue(false) == true ? '미섭취' : '섭취 완료',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6FCF97),
                ),
              ),
            ],
          ),
          for (String name in eatInfoMap.keys)
            Padding(
              padding: const EdgeInsets.only(left: 64.0, bottom: 12),
              child: Row(
                children: [
                  Text(
                    '• ' + name,
                    style: TextStyle(fontSize: 12),
                  ),
                  const Spacer(),
                  Text(
                    eatInfoMap[name] == true ? '섭취 완료' : '미섭취',
                    style: eatInfoMap[name] == true
                        ? const TextStyle(fontSize: 12)
                        : const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF9500),
                          ),
                  ),
                ],
              ),
            ),
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
      body: Stack(
        children: <Widget>[
          // 캘린더 부분
          Column(
            children: <Widget>[
              calenderSelect(selectedTime: _calendarDate),
              const SizedBox(height: 10),
              heatMap(width: 7, height: 6, input: {
                DateTime(2021, 12, 8): 2,
                DateTime(2021, 12, 1): 3,
              }),
              Container(
                width: 40,
                height: 40,
                color: Colors.black,
              ),
            ],
          ),
          // Bottom Sheet 부분
          DraggableScrollableSheet(
              initialChildSize: 0.3,
              minChildSize: 0.3,
              maxChildSize: 0.7,
              builder: (context, scrollController) {
                return Container(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: ListView(
                    controller: scrollController,
                    physics: ClampingScrollPhysics(),
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(
                            top: 14, bottom: 28, left: 100, right: 100),
                        width: 10,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: Color(0xFFD6D6D6),
                          borderRadius: BorderRadius.all(
                            Radius.circular(2),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '${_selectedDate.month}월 ${_selectedDate.day}일 섭취 이력',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            '${(5 / 6 * 100).floor()}%',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF9500)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      eatInfoList(
                        title: '아침',
                        hours: 8,
                        minutes: 30,
                        eatInfoMap: {
                          "KrikLand 오메가3": true,
                          "KrikLand 비타민C": false
                        },
                      ),
                      eatInfoList(
                        title: '점심',
                        hours: 13,
                        minutes: 30,
                        eatInfoMap: {
                          "KrikLand 오메가3": true,
                          "KrikLand 비타민C": true
                        },
                      ),
                      eatInfoList(
                        title: '저녁',
                        hours: 20,
                        minutes: 30,
                        eatInfoMap: {
                          "KrikLand 오메가3": true,
                          "KrikLand 비타민C": true
                        },
                      ),
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
                );
              }),
        ],
      ),
    );
  }
}
