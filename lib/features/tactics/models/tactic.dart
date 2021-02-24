import 'package:flutter/foundation.dart';
import 'package:tactics_trainer_app/core/utils.dart';

class TacticMove {

  final String fen;
  final String san;

  TacticMove({this.fen, this.san});

}

class Tactic {
  final String id;
  final String blunderMove;
  final List<String> solution;
  final String fen;
  final List<TacticMove> _moves = [];

  Tactic({
    @required this.id,
    @required this.fen,
    @required this.blunderMove,
    @required this.solution,
  }) {

    _moves.add(TacticMove(fen: fen, san: blunderMove));

    String nextFen = makeMove(fen, blunderMove);

    solution.forEach((san) {
      _moves.add(TacticMove(fen: nextFen, san: san));
      nextFen = makeMove(nextFen, san);
    });

    _moves.add(TacticMove(fen: nextFen, san: null));
  }

  List<TacticMove> get moves => _moves;
}
