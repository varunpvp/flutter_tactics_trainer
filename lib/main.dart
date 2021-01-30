import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tactics_trainer_app/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tactics Trainer',
      theme: ThemeData(
        primaryColor: Color(0xff282622),
        textTheme: GoogleFonts.procionoTextTheme(),
      ),
      home: HomePage(),
    );
  }
}
