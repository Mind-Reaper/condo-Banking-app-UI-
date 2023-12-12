// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeProvider with ChangeNotifier {
  bool darkMode = false;

  changeTheme() {
    darkMode = !darkMode;
    notifyListeners();
  }

  ThemeData light = ThemeData(
    scaffoldBackgroundColor: Color(0xffF5F5F5),
    bottomSheetTheme: BottomSheetThemeData(
        elevation: 0,
        modalBackgroundColor: Colors.transparent,
        backgroundColor: Colors.transparent),
    brightness: Brightness.light,
    canvasColor: Colors.grey[300],
    appBarTheme: AppBarTheme(
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: GoogleFonts.poppins(color: Colors.black)),
    primaryTextTheme:
        GoogleFonts.poppinsTextTheme().apply(bodyColor: Colors.black),
    iconTheme: IconThemeData(color: Colors.black),
    textTheme:
        GoogleFonts.poppinsTextTheme().apply(bodyColor: Color(0xff8E8E93)),
    primaryIconTheme: IconThemeData(color: Color(0xff8E8E93)),
    primaryColor: Colors.white,
    secondaryHeaderColor: Color(0xff32d74b),
    indicatorColor: Color(0xffF5F5F5),
    cardColor: Colors.white,
  );

  ThemeData dark = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    bottomSheetTheme: BottomSheetThemeData(
        elevation: 0,
        modalBackgroundColor: Colors.transparent,
        backgroundColor: Colors.transparent),
    brightness: Brightness.dark,
    canvasColor: Color(0xff3A3A3C),
    appBarTheme: AppBarTheme(
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: GoogleFonts.poppins(color: Colors.white)),
    indicatorColor: Color(0xff2C2C2E),
    primaryTextTheme:
        GoogleFonts.poppinsTextTheme().apply(bodyColor: Colors.white),
    iconTheme: IconThemeData(color: Colors.white),
    textTheme: GoogleFonts.poppinsTextTheme().apply(
      bodyColor: Color(0xff8E8E93),
    ),
    primaryIconTheme: IconThemeData(color: Colors.white),
    primaryColor: Colors.black,
    secondaryHeaderColor: Colors.white,
    cardColor: Color(0xff1C1C1E),
  );
}
