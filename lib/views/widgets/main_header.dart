import 'package:flutter/material.dart';
import '../../data/color.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainHeader extends StatelessWidget {
  DateTime _now = DateTime.now();

  final String userName;
  final String userImage;
  final int? age;
  final String? sex;
  final String? address;
  final List<DateTime>? eatTimes;
  final List<bool>? ateList;

  MainHeader({
    this.userName = '게스트',
    this.userImage = '',
    this.age,
    this.sex,
    this.address,
    this.eatTimes,
    this.ateList,
  });

  Widget pillColumn({
    required DateTime eatTime,
    required bool ate,
    required bool next,
    required String title,
  }) {
    DateTime remainTime = DateTime(
        eatTime.year - _now.year,
        eatTime.month - _now.month,
        eatTime.day - _now.day,
        eatTime.hour - _now.hour,
        eatTime.minute - _now.minute);
    return Container(
      margin: const EdgeInsets.only(top: 4, bottom: 4),
      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 5, right: 10),
      width: double.infinity,
      height: 68,
      decoration: next
          ? BoxDecoration(
              color: const Color(0xFF6FCF97).withOpacity(0.1),
              borderRadius: const BorderRadius.all(
                Radius.circular(12),
              ),
            )
          : null,
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 26,
            child: eatTime.isBefore(_now)
                ? const Icon(
                    Icons.close_sharp,
                    size: 28,
                    color: Color(0xFFE56060),
                  )
                : ate
                    ? const Icon(
                        Icons.check_sharp,
                        size: 28,
                        color: Color(0xFF6FCF97),
                      )
                    : SvgPicture.asset('assets/images/medicine_fill.svg',
                        width: 28, height: 28),
            backgroundColor: ate
                ? Color(0xFFF8F9FA)
                : const Color(0xFF53B175).withOpacity(0.1),
          ),
          const SizedBox(width: 12),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.end,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(width: 12),
              Text(
                (eatTime.hour >= 12 && eatTime.hour < 24 ? '오후 ' : '오전 ') +
                    (eatTime.hour == 12 ? 12 : (eatTime.hour % 12)).toString() +
                    '시 ' +
                    eatTime.minute.toString() +
                    '분',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 12,
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            eatTime.isBefore(_now)
                ? '섭취 X'
                : ate
                    ? '섭취 완료'
                    : remainTime.hour.toString() +
                        '시간 ' +
                        remainTime.minute.toString() +
                        '분 남음',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: eatTime.isBefore(_now)
                  ? Color(0xFFE56060)
                  : ate
                      ? Color(0xFF6FCF97)
                      : Color(0xFFFF9500),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child: Stack(
        children: <Widget>[
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    text: '안녕하세요\n',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: '$userName님 ☀️\n',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      TextSpan(
                          text: age == null ? '' : '$age세 | $sex | $address',
                          style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  // child: CircleAvatar(
                  //   radius: 24,
                  //   backgroundColor: Colors.white,
                  //   foregroundImage: userImage,
                  // ),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(userImage ?? '')
                      )
                    )
                  ),
                  onTap: () => Navigator.of(context).pushNamed('/mypage'),
                ),
              ],
            ),
            width: double.infinity,
            height: 272,
            padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
            decoration: BoxDecoration(
                color: EasyPillColor.primaryColor(),
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(60),
                    bottomRight: Radius.circular(60))),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(left: 18, right: 18, top: 150),
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF78C6A3).withOpacity(0.38),
                  blurRadius: 38,
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: <Widget>[
                    const Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '금일 섭취 이력',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      child: Text(
                        '자세히보기',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black.withOpacity(0.4),
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pushNamed('/eat'),
                    ),
                  ],
                ),
                pillColumn(
                    eatTime: eatTimes?[0] ?? DateTime.now(),
                    ate: ateList?[0] ?? false,
                    next: (eatTimes?[0].isAfter(_now) ?? false),
                    title: '아침'),
                pillColumn(
                    eatTime: eatTimes?[1] ?? DateTime.now(),
                    ate: ateList?[1] ?? false,
                    next: (eatTimes?[0].isBefore(_now) ?? false) &&
                        (eatTimes?[1].isAfter(_now) ?? false) &&
                        ateList?[1] == false,
                    title: '점심'),
                pillColumn(
                    eatTime: eatTimes?[2] ?? DateTime.now(),
                    ate: ateList?[2] ?? false,
                    next: (eatTimes?[1].isBefore(_now) ?? false) &&
                        (eatTimes?[2].isAfter(_now) ?? false) &&
                        (ateList?[2] == false),
                    title: '저녁'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
