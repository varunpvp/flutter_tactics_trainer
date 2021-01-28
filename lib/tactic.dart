class Tactic {
  final String blunderMove;
  final List<String> solution;
  final String fen;

  Tactic({
    this.fen,
    this.blunderMove,
    this.solution,
  });

  factory Tactic.fromJson(json) {
    return Tactic(
      fen: json['fen'],
      blunderMove: json['blunderMove'],
      solution: json['solution'],
    );
  }
}
