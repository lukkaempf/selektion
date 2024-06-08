import 'package:flutter/material.dart';
import 'package:selektion/model/player.dart';
import 'package:selektion/routes.dart';

class PlayerCard extends StatefulWidget {
  final int teamid;
  final Player player;

  const PlayerCard({required this.teamid, required this.player, super.key});

  @override
  State<PlayerCard> createState() => _PlayerCardState();
}

class _PlayerCardState extends State<PlayerCard> {
  @override
  Widget build(BuildContext context) {
    int countRatings = widget.player.ratings.length;

    return Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.ratingScreen,
              arguments: {'teamId': widget.teamid, 'player': widget.player});
        },
        child: SizedBox(
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.player.number.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Text('${countRatings.toString()} Ratings'),
            ],
          )),
        ),
      ),
    );
  }
}
