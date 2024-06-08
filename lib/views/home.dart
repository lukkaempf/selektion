import 'package:flutter/material.dart';
import 'package:selektion/routes.dart';
import 'package:selektion/services/local_player_service.dart';
import 'package:selektion/widgets/custom_button.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomElevatedButton(
              width: 200,
              text: 'Löschen',
              onPressed: () {
                LocalDatabaseService.instance.deleteEverything();
              },
            ),
            const SizedBox(
              height: 20,
            ),
            CustomElevatedButton(
              width: 200,
              text: 'Start',
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.teamScreen);
              },
            ),
            const SizedBox(
              height: 20,
            ),
            CustomElevatedButton(
              width: 200,
              text: 'Auswertung',
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.analysisScreen);
              },
            ),
            /*   CustomElevatedButton(
              width: 200,
              text: 'CREATE TEAM',
              onPressed: () {
                Player firstPlayer = Player(1, [], false);
                Player secondPlayer = Player(
                    1, [Rating.gut, Rating.genuegend, Rating.genuegend], false);

                Team tempTeam =
                    Team(name: 'Team1', players: [firstPlayer, secondPlayer]);
                LocalDatabaseService.instance.createTeam(tempTeam);
              },
            ),
            CustomElevatedButton(
              width: 200,
              text: 'CREATE TEAM 2',
              onPressed: () {
                Player firstPlayer = Player(1, [], false);
                Player secondPlayer =
                    Player(1, [Rating.gut, Rating.gut, Rating.gut], false);

                Team tempTeam =
                    Team(name: '2 Team', players: [firstPlayer, secondPlayer]);
                LocalDatabaseService.instance.createTeam(tempTeam);
              },
            ),
            CustomElevatedButton(
              width: 200,
              text: 'CREATE many 2',
              onPressed: () {
                List<Player> players = [];
                for (int i = 0; i < 20; i++) {
                  players.add(Player(i, [], false));
                }

                Team tempTeam = Team(name: 'Team many', players: players);
                LocalDatabaseService.instance.createTeam(tempTeam);
              },
            ),
            */
            /*  CustomElevatedButton(
              width: 200,
              text: 'delete db',
              onPressed: () {
                LocalDatabaseService.instance.deleteDb();
              },
            ), */
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return AppBar(
      title: const Text('Selektion'),
      automaticallyImplyLeading: false,
    );
  }
}
