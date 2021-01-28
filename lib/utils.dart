import 'package:chess/chess.dart';

class FullMove {
  final Move move;
  final String fen;

  FullMove({
    this.fen,
    this.move,
  });
}

FullMove makeMove(String fen, dynamic move) {
  final chess = Chess.fromFEN(fen);

  if (chess.move(move)) {
    final fen = chess.fen;
    return FullMove(
      fen: fen,
      move: chess.undo_move(),
    );
  }

  return null;
}

// FullMove validateMove(String fen, dynamic move, List<String> solution) {
//
//   final fullMove = makeMove(fen, move);
//
//
//
//   if (fullMove == null) {
//
//     return null;
//   }
//
//   final san =
//
//   if ()
//
// }
