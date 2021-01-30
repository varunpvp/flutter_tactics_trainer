import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_stateless_chessboard/flutter_stateless_chessboard.dart';
import 'package:tactics_trainer_app/core/utils.dart';
import 'package:tactics_trainer_app/features/tactics/models/tactic.dart';

class TacticBoard extends StatefulWidget {
  final Tactic tactic;
  final void Function() onSolve;
  final void Function() onCorrect;
  final void Function() onIncorrect;

  TacticBoard({
    @required Key key,
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

    Future.delayed(Duration(milliseconds: 500)).then((_) {
      final move = makeMove(_fen, widget.tactic.blunderMove);
      setState(() {
        _fen = move['fen'];
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final size = min(media.width, media.height);

    return Chessboard(
      fen: _fen,
      size: size,
      orientation: getSideToMove(widget.tactic.fen) == 'w' ? 'b' : 'w',
      onMove: (move) {
        if (_solution.isEmpty) {
          return;
        }

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

            Future.delayed(Duration(milliseconds: 500)).then((value) {
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
