import 'dart:convert';
import 'dart:math';

import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stateless_chessboard/flutter_stateless_chessboard.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:tactics_trainer_app/core/utils.dart';
import 'package:tactics_trainer_app/features/tactics/models/tactic.dart';
import 'package:wakelock/wakelock.dart';

class PlayTacticsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PlayTacticsPageState();
  }
}

class _PlayTacticsPageState extends State<PlayTacticsPage> {
  List<Tactic> _tactics = [];
  String _state = "side";
  int _moveIndex = 0;
  int _solvedMoveIndex = 0;

  @override
  void initState() {
    _loadTactic();
    _loadTactic();
    Wakelock.enable();
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
    final media = MediaQuery.of(context).size;
    final size = min(media.width, media.height);

    if (_tactics.isEmpty) {
      return Container(
        color: theme.primaryColor,
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      );
    }

    final tactic = _tactics.first;
    final tacticMove = tactic.moves[_moveIndex];

    return Container(
      color: theme.primaryColor,
      child: Column(
        children: [
          Chessboard(
            fen: tacticMove.fen,
            size: size,
            orientation: getSideToMove(tactic.fen) == 'w' ? 'b' : 'w',
            onMove: (move) {
              final san = getSanFromShortMove(tacticMove.fen, move);

              if (san == tacticMove.san) {
                if (_moveIndex == tactic.moves.length - 1) {
                  setState(() {
                    _state = "solved";
                  });
                } else {
                  setState(() {
                    _moveIndex += 1;
                    _solvedMoveIndex += 1;
                    _state = "correct";
                  });

                  if (_moveIndex != tactic.moves.length - 1) {
                    Future.delayed(Duration(milliseconds: 500)).then((_) {
                      setState(() {
                        _moveIndex += 1;
                        _solvedMoveIndex += 1;
                      });
                    });
                  } else {
                    setState(() {
                      _state = "solved";
                    });
                  }
                }
              } else {
                setState(() {
                  _state = "incorrect";
                });
              }
            },
          ),
          Row(
            children: [
              Expanded(
                child: IconButton(
                  color: Colors.white,
                  icon: Icon(Icons.skip_previous),
                  onPressed: _moveIndex > 0
                      ? () {
                          setState(() {
                            _moveIndex -= 1;
                          });
                        }
                      : null,
                ),
              ),
              Expanded(
                child: IconButton(
                  color: Colors.white,
                  icon: Icon(Icons.skip_next),
                  onPressed: _moveIndex < _solvedMoveIndex
                      ? () {
                          setState(() {
                            _moveIndex += 1;
                          });
                        }
                      : null,
                ),
              ),
            ],
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
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _tactics = _tactics.sublist(1);
                        _state = "side";
                        _moveIndex = 0;
                        _solvedMoveIndex = 0;
                      });
                      if (_tactics.isNotEmpty) {
                        Future.delayed(Duration(milliseconds: 1000)).then((_) {
                          setState(() {
                            _moveIndex = 1;
                            _solvedMoveIndex = 1;
                          });
                        });
                      }
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
      if (_tactics.isEmpty) {
        _state = "side";
      }
      _tactics.add(tactic);
    });

    Future.delayed(Duration(milliseconds: 1000)).then((_) {
      setState(() {
        _moveIndex = 1;
        _solvedMoveIndex = 1;
      });
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
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
            Visibility(
              visible: _tactics.isNotEmpty &&
                  _solvedMoveIndex < _tactics.first.moves.length - 1,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _solvedMoveIndex = _tactics.first.moves.length - 1;
                  });
                },
                child: Text("View solution"),
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

  @override
  void dispose() {
    Wakelock.disable();
    super.dispose();
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
