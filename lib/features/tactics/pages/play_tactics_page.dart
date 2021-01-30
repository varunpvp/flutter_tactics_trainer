import 'dart:convert';

import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:tactics_trainer_app/core/utils.dart';
import 'package:tactics_trainer_app/features/tactics/models/tactic.dart';
import 'package:tactics_trainer_app/features/tactics/widgets/tactic_board.dart';

class PlayTacticsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PlayTacticsPageState();
  }
}

class _PlayTacticsPageState extends State<PlayTacticsPage> {
  List<Tactic> _tactics = [];
  String _state = "side";

  @override
  void initState() {
    _loadTactic();
    _loadTactic();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Tactics Trainer',
          style: GoogleFonts.prociono(),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final theme = Theme.of(context);

    if (_tactics.isEmpty) {
      return Container(
        color: theme.primaryColor,
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      );
    }

    final tactic = _tactics.first;

    return Container(
      color: theme.primaryColor,
      child: Column(
        children: [
          TacticBoard(
            key: ValueKey(tactic.id),
            tactic: tactic,
            onSolve: () {
              setState(() {
                _state = "solved";
              });
            },
            onCorrect: () {
              setState(() {
                _state = "correct";
              });
            },
            onIncorrect: () {
              setState(() {
                _state = "incorrect";
              });
            },
          ),
          if (_state == 'side')
            _buildSideToPlay(getSideToMove(tactic.fen) == 'w' ? 'b' : 'w'),
          if (_state == 'correct') _buildCorrectMove(),
          if (_state == 'incorrect') _buildIncorrectMove(),
          if (_state == 'solved') _buildSolved(),
          Container(
            height: 50.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Expanded(
                //   child: RaisedButton(
                //     materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                //     onPressed: () => null,
                //     child: Text("Show Solution"),
                //   ),
                // ),
                Expanded(
                  child: RaisedButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onPressed: () {
                      setState(() {
                        _tactics = _tactics.sublist(1);
                        _state = "side";
                      });
                      _loadTactic();
                    },
                    child: Text("Next"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _loadTactic() async {
    final tactic = await fetchTactic();

    setState(() {
      _tactics.add(tactic);
    });
  }

  Widget _buildSideToPlay(String side) {
    return Expanded(
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (side == 'w') WhiteKing(size: 32),
            if (side == 'b') BlackKing(size: 32),
            SizedBox(width: 4),
            Text(
              "${side == 'w' ? 'White' : 'Black'} to Play!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncorrectMove() {
    return Expanded(
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage("assets/images/incorrect.png"),
              width: 32,
              height: 32,
            ),
            SizedBox(width: 4),
            Text(
              "Incorrect! Try something else",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCorrectMove() {
    return Expanded(
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage("assets/images/correct.png"),
              width: 32,
              height: 32,
            ),

            // WhiteKing(size: 32),
            SizedBox(width: 4),
            Text(
              "Correct! Keep going...",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSolved() {
    return Expanded(
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage("assets/images/correct.png"),
              width: 32,
              height: 32,
            ),

            // WhiteKing(size: 32),
            SizedBox(width: 4),
            Text(
              "Solved!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<Tactic> fetchTactic() async {
  final res = await http.post(
    "https://chessblunders.org/api/blunder/get",
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode({
      'type': 'explore',
    }),
  );

  final bodyJson = json.decode(res.body);
  final data = bodyJson['data'];

  return Tactic(
    id: data['id'],
    fen: data['fenBefore'],
    blunderMove: data['blunderMove'],
    solution: data['forcedLine'].map<String>((move) => move as String).toList(),
  );
}
