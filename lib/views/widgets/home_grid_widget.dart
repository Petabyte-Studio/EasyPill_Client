import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeGridWidget extends StatelessWidget {
  final int axisCount;
  final List<String>? titles;
  final List<String>? subtitles;
  final List<Color>? backgroundColors;
  final List<Color>? textColors;
  final List<String>? icons;
  final List<Function>? callbacks;

  HomeGridWidget({
    this.axisCount = 2,
    this.titles,
    this.subtitles,
    this.backgroundColors,
    this.textColors,
    this.icons,
    this.callbacks,
  });

  Widget rectangleContainer({
    String? title,
    EdgeInsets? margin,
    String? subtitle,
    Color? backgroundColor,
    Color? textColor,
    Function? callback,
    String? icon,
  }) {
    // child: InkWell(
    //   splashFactory: NoSplash.splashFactory,
    //   borderRadius: BorderRadius.circular(11.0),
    //   child: Ink(

    return AspectRatio(
      aspectRatio: 1,
      child: GestureDetector(
        onTap: () => callback!(),
        child: Container(
          margin: margin,
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.white,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 20),
            child: Stack(
              children: <Widget>[
                Text(
                  title ?? '',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                Positioned(
                  bottom: 24,
                  right: 0,
                  child: SvgPicture.asset(icon ?? '', width: 70, height: 60),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        subtitle ?? '',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, size: 16, color: textColor),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.count(
        crossAxisCount: axisCount,
        padding: const EdgeInsets.all(10),
        children: List.generate(titles?.length ?? 0, (index) {
          return rectangleContainer(
            title: titles?[index],
            subtitle: subtitles?[index],
            icon: icons?[index],
            textColor: textColors?[index],
            backgroundColor: backgroundColors?[index],
            callback: callbacks?[index],
            margin: const EdgeInsets.all(10),
          );
        }),
      ),
    );
  }
}
