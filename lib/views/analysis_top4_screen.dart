import 'package:flutter/material.dart';
import 'package:selektion/model/player.dart';
import 'package:selektion/services/local_player_service.dart';

class AnalysisTop4 extends StatefulWidget {
  const AnalysisTop4({super.key});

  @override
  State<AnalysisTop4> createState() => _AnalysisTop4State();
}

class _AnalysisTop4State extends State<AnalysisTop4> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(context),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const Center(
              child:
                  Text('Folgende Spielernummern wurden als Top4 ausgewählt.')),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: FutureBuilder(
              future: LocalDatabaseService.instance.getAllTop4Players(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Text('Noch keine Daten');
                }

                if (snapshot.data!.isEmpty) {
                  return const Text('Noch keine Daten');
                }

                List<Player> players = snapshot.data!;

                return ListView.builder(
                  itemCount: players.length,
                  itemBuilder: (context, index) {
                    return Text(
                      'Spieler Nummer: ${players[index].number}',
                      textAlign: TextAlign.center,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return AppBar(
        title: const Text('Top 4 Spieler'),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)));
  }
}
