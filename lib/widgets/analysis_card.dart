import 'package:flutter/material.dart';
import 'package:selektion/model/rating.dart';
import 'package:selektion/model/team.dart';

class AnalysisCard extends StatefulWidget {
  final Team team;
  const AnalysisCard({required this.team, super.key});

  @override
  State<AnalysisCard> createState() => _AnalysisCardState();
}

class _AnalysisCardState extends State<AnalysisCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
          height: 210,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Text(
                  widget.team.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Spieler'),
                      Text('ungenügend'),
                      Text('genügend'),
                      Text('gut'),
                      Text('sehrgut'),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.team.players.length,
                    itemBuilder: (context, index) {
                      int countungenuegend = widget.team.players[index].ratings
                          .where((element) => element == Rating.ungenduegend)
                          .length;

                      int countgenuegend = widget.team.players[index].ratings
                          .where((element) => element == Rating.genuegend)
                          .length;

                      int countGut = widget.team.players[index].ratings
                          .where((element) => element == Rating.gut)
                          .length;

                      int countSehrGut = widget.team.players[index].ratings
                          .where((element) => element == Rating.sehrgut)
                          .length;

                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  'Spieler: ${widget.team.players[index].number.toString()}'),
                              Text(countungenuegend.toString()),
                              Text(countgenuegend.toString()),
                              Text(countGut.toString()),
                              Text(countSehrGut.toString()),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
