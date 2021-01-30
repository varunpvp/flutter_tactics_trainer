import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tactics_trainer_app/features/tactics/models/tactic.dart';
import 'package:tactics_trainer_app/features/tactics/widgets/tactic_board.dart';

class PlayTacticsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PlayTacticsPageState();
  }
}

class _PlayTacticsPageState extends State<PlayTacticsPage> {
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
