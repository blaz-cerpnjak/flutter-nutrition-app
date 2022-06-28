
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
  backgroundColor: const Color(0xfff7f7fa),
  textTheme: GoogleFonts.firaSansTextTheme(),
  primaryColor: const Color(0xff38383b),
  bottomAppBarColor: Colors.white,
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.blue,
  backgroundColor: const Color(0xff303131),
  textTheme: GoogleFonts.firaSansTextTheme(),
  primaryColor: Colors.white,
  bottomAppBarColor: const Color(0xff222224),
);