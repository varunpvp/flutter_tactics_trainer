import 'package:flutter/material.dart';
import 'package:tactics_trainer_app/features/tactics/pages/play_tactics_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        color: theme.primaryColor,
        alignment: Alignment.center,
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Chess Tactics Trainer",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Improve your skills with more that 1,700,000 tactics",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 20),
                  RaisedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PlayTacticsPage(),
                        ),
                      );
                    },
                    child: Text("Start Playing!"),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: IconButton(
                icon: Icon(Icons.info, color: Colors.white),
                onPressed: () {
                  showAboutDialog(
                    context: context,
                    applicationName: "Tactics Trainer",
                    applicationVersion: 'v1.0',
                    children: [
                      Text("Tactics provided by chessblunders.org"),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
