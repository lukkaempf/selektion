import 'package:flutter/material.dart';
import 'package:selektion/model/team.dart';
import 'package:selektion/widgets/player_card.dart';

class PlayerScreen extends StatefulWidget {
  final Team team;

  const PlayerScreen({required this.team, super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppbar(context),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: widget.team.players.length,
              itemBuilder: ((context, index) {
                return PlayerCard(
                    teamid: widget.team.id!,
                    player: widget.team.players[index]);
              })),
        ));
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return AppBar(
        title: const Text('Spieler'),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)));
  }
}
