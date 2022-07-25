import 'package:flutter/material.dart';

class GlobalColors {
  static Color backGroundColor =  Colors.white;
  static Gradient gradientColors = const LinearGradient(
    colors: [

      Color(0xffd0eaf9),
      Color(0xffc9b6e9),
    ],
  );
  static Color buttonBlack =  Colors.black87;
  static Color lightPink = const Color(0xffc9b6e9);
  static Color? textField = Colors.grey[200];
  static Color back =  Colors.white;
}

const MaterialColor primaryBlack = MaterialColor(
  _blackPrimaryValue,
  <int, Color>{
    50: Color(0xFF000000),
    100: Color(0xFF000000),
    200: Color(0xFF000000),
    300: Color(0xFF000000),
    400: Color(0xFF000000),
    500: Color(_blackPrimaryValue),
    600: Color(0xFF000000),
    700: Color(0xFF000000),
    800: Color(0xFF000000),
    900: Color(0xFF000000),
  },
);
const int _blackPrimaryValue = 0xFFFFFFFF;

 String getTimeFormat(int time) {
String date = '';

if (time > 0) {
int years = (time / 31104000000).floor();
if (years < 1) {
int months = (time / 2592000000).floor();
if (months < 1) {
int week = (time / 604800000).floor();
if (week < 1) {
int day = (time / 86400000).floor();
if (day < 1) {
int hours = (time / 3600000).floor();
if (hours < 1) {
int min = (time / 60000).floor();
if (min < 1) {
int sec = (time / 60000).floor();
if (sec < 1) {
date = 'Just Now';
} else {
date = '${sec}sec';
}
} else {
date = '${min}m';
}
} else {
date = '${hours}h';
}
} else {
date = '${day}d';
}
} else {
date = '${week}w';
}
} else {
date = '${months}mon';
}
} else {
date = '${years}yrs';
}
}

print(date+"   "+time.toString());
return date;
}


