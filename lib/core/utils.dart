import 'package:chess/chess.dart';

dynamic makeMove(String fen, dynamic move) {
  final chess = Chess.fromFEN(fen);

  if (chess.move(move)) {
    final fen = chess.fen;
    final move = chess.undo_move();
    final san = chess.move_to_san(move);

    return {
      'fen': fen,
      'san': san,
    };
  }

  return null;
}

dynamic validateMove(String fen, dynamic move, List<String> solution) {
  final next = makeMove(fen, move);

  if (next != null && solution.isNotEmpty && next['san'] == solution.first) {
    return {
      'fen': next['fen'],
      'solution': solution.sublist(1),
    };
  }

  return null;
}

String getSideToMove(String fen) {
  final chess = Chess.fromFEN(fen);
  return chess.turn == Color.WHITE ? 'w' : 'b';
}
