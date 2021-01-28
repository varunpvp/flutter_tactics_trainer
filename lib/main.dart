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
  List<Tactic> tactics = [];

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
      onSolve: () {},
      onCorrect: () {},
      onIncorrect: () {},
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Chessboard(
      fen: _fen,
      size: size.width,
      onMove: (move) {
        final next = makeMove(_fen, {
          'from': move.from,
          'to': move.to,
          'promotion': 'q',
        });

        if (next != null) {}
      },
    );
  }
}
