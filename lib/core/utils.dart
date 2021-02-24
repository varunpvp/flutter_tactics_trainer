import 'package:chess/chess.dart';
import 'package:flutter_stateless_chessboard/types.dart';

String makeMove(String fen, dynamic move) {
  final chess = Chess.fromFEN(fen);

  if (chess.move(move)) {
    return chess.fen;
  }

  return null;
}

String getSanFromShortMove(String fen, ShortMove move) {
  final chess = Chess.fromFEN(fen);
  if (chess.move({
    'from': move.from,
    'to': move.to,
    'promotion': move.promotion,
  })) {
    return chess.move_to_san(chess.undo_move());
  }

  return null;
}

String getSideToMove(String fen) {
  final chess = Chess.fromFEN(fen);
  return chess.turn == Color.WHITE ? 'w' : 'b';
}
