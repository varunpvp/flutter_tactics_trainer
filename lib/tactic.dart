import 'package:flutter/foundation.dart';

class Tactic {
  final String id;
  final String blunderMove;
  final List<String> solution;
  final String fen;

  Tactic({
    @required this.id,
    @required this.fen,
    @required this.blunderMove,
    @required this.solution,
  });
}
