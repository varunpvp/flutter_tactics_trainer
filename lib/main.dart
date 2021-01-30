import 'package:flutter/material.dart';
import 'package:flutter_stateless_chessboard/flutter_stateless_chessboard.dart';
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
  List<Tactic> tactics = [
    Tactic(
      fen: "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1",
      blunderMove: "c4",
      solution: [
        "e5",
        "Nc3",
        "Nf6",
        "Nf3",
      ],
    ),
  ];

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
      tactic: tactics.first,
      onSolve: () {
        print('solved');
      },
      onCorrect: () {
        print('correct!');
      },
      onIncorrect: () {
        print('incorrect');
      },
    );
  }
}

class TacticBoard extends StatefulWidget {
  final Tactic tactic;
  final void Function() onSolve;
  final void Function() onCorrect;
  final void Function() onIncorrect;

  TacticBoard({
    @required this.tactic,
    @required this.onCorrect,
    @required this.onIncorrect,
    @required this.onSolve,
  });

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

    Future.delayed(Duration(milliseconds: 300)).then((value) {
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
