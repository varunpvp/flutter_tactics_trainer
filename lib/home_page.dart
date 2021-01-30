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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Tactics Trainer",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Improve your tactics skills with more that 1,700,000 problems",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 20),
            RaisedButton(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PlayTacticsPage(),
                  ),
                );
              },
              child: Text("Start Playing!"),
            )
          ],
        ),
      ),
    );
  }
}
