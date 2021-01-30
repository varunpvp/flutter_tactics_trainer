import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stateless_chessboard/flutter_stateless_chessboard.dart';
import 'package:http/http.dart' as http;
import 'package:tactics_trainer_app/tactic.dart';
import 'package:tactics_trainer_app/utils.dart';

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
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  List<Tactic> tactics = [];

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
        title: Text("Tactic Trainer"),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (tactics.isEmpty) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return TacticBoard(
      key: ValueKey(tactics.first.id),
      tactic: tactics.first,
      onSolve: () {
        setState(() {
          tactics = tactics.sublist(1);
        });

        _loadTactic();
      },
      onCorrect: () {
        print('correct!');
      },
      onIncorrect: () {
        print('incorrect');
      },
    );
  }

  void _loadTactic() async {
    final tactic = await fetchTactic();

    setState(() {
      tactics.add(tactic);
    });
  }
}

class TacticBoard extends StatefulWidget {
  final Tactic tactic;
  final void Function() onSolve;
  final void Function() onCorrect;
  final void Function() onIncorrect;

  TacticBoard({
    Key key,
    @required this.tactic,
    @required this.onCorrect,
    @required this.onIncorrect,
    @required this.onSolve,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TacticBoardState();
  }
}

class TacticBoardState extends State<TacticBoard> {
  String _fen;
  List<String> _solution;

  @override
  void initState() {
    _fen = widget.tactic.fen;
    _solution = widget.tactic.solution;

    Future.delayed(Duration(milliseconds: 1000)).then((_) {
      final move = makeMove(_fen, widget.tactic.blunderMove);
      setState(() {
        _fen = move['fen'];
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Chessboard(
      fen: _fen,
      size: size.width,
      orientation: getSideToMove(widget.tactic.fen) == 'w' ? 'b' : 'w',
      onMove: (move) {
        final next = validateMove(
          _fen,
          {
            'from': move.from,
            'to': move.to,
            'promotion': 'q',
          },
          _solution,
        );

        if (next != null) {
          setState(() {
            _fen = next['fen'];
            _solution = next['solution'];
          });

          if (_solution.isNotEmpty) {
            widget.onCorrect();

            Future.delayed(Duration(milliseconds: 300)).then((value) {
              final computerNext = validateMove(
                _fen,
                _solution.first,
                _solution,
              );

              setState(() {
                _fen = computerNext['fen'];
                _solution = computerNext['solution'];
              });

              if (_solution.isEmpty) {
                widget.onSolve();
              }
            });
          } else {
            widget.onSolve();
          }
        } else {
          widget.onIncorrect();
        }
      },
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
