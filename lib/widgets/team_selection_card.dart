import 'package:flutter/material.dart';
import 'package:selektion/model/team.dart';
import 'package:selektion/routes.dart';

class TeamCard extends StatefulWidget {
  final Team team;

  const TeamCard({required this.team, super.key});

  @override
  State<TeamCard> createState() => _TeamCardState();
}

class _TeamCardState extends State<TeamCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      child: Card(
          child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.playerScreen,
              arguments: widget.team);
        },
        child: SizedBox(
          width: double.infinity,
          height: 60,
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.team.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Text('${widget.team.players.length.toString()} Spieler'),
            ],
          )),
        ),
      )),
    );
  }
}
