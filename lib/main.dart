import 'package:flutter/material.dart';
import 'package:tactics_trainer_app/features/tactics/pages/play_tactics_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tactics Trainer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PlayTacticsPage(),
    );
  }
}
