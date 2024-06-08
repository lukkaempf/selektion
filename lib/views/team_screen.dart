import 'package:flutter/material.dart';
import 'package:selektion/model/player.dart';
import 'package:selektion/model/team.dart';
import 'package:selektion/services/local_player_service.dart';
import 'package:selektion/utilities/error_dialog.dart';
import 'package:selektion/widgets/team_selection_card.dart';

class TeamScreen extends StatefulWidget {
  const TeamScreen({super.key});

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  final TextEditingController _teamNameController = TextEditingController();
  final TextEditingController _playerNumbersController =
      TextEditingController();

  void refreshPage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(context),
      body: FutureBuilder(
        future: LocalDatabaseService.instance.getAllTeams(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Noch keine Teams.'),
            );
          }
          List<Team> teams = snapshot.data!;
          return ListView.builder(
              itemCount: teams.length,
              itemBuilder: (context, index) {
                return TeamCard(team: teams[index]);
              });
        },
      ),
    );
  }

  void _showCreateTeamDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Neues Team erstellen'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _teamNameController,
                  decoration:
                      const InputDecoration(hintText: 'Teamname eingeben'),
                ),
                TextField(
                  controller: _playerNumbersController,
                  decoration: const InputDecoration(
                      hintText: 'Spielernummer (Komma getrennt)'),
                  keyboardType:
                      const TextInputType.numberWithOptions(signed: true),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Abbrechen'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Erstellen'),
              onPressed: () {
                _createTeam();
              },
            ),
          ],
        );
      },
    );
  }

  void _createTeam() {
    //check if team name is empty
    if (_teamNameController.text.isEmpty) {
      ErrorDialog.customError(context, 'Team Name darf nicht leer sein.');
      Navigator.of(context).pop();
      return;
    }

    //check if player numbers are empty
    if (_playerNumbersController.text.isEmpty) {
      ErrorDialog.customError(
          context, 'Spieler Nummern dürfen nicht leer sein.');
      Navigator.of(context).pop();
      return;
    }

    //check if only used allowed characters
    final regex = RegExp(r'^[0-9,]*$');

    if (!regex.hasMatch(_playerNumbersController.text)) {
      ErrorDialog.customError(context, 'Nur Zahlen und Kommas sind erlaubt.');
      Navigator.of(context).pop();
      return;
    }
    //get list
    List<String> stringNumbers = _playerNumbersController.text.split(',');

    //convert string list to int list
    List<int> playerNumbers =
        stringNumbers.map((str) => int.parse(str.trim())).toList();

    //check for double player numbers
    Set<int> setFromList = Set.from(playerNumbers);
    if (setFromList.length != playerNumbers.length) {
      ErrorDialog.customError(
          context, 'Spieler Nummern müssen eindeutig sein.');
      Navigator.of(context).pop();
      return;
    }

    //create players object
    List<Player> players = [];

    for (int i = 0; i < playerNumbers.length; i++) {
      Player player = Player(playerNumbers[i], [], false, '');
      players.add(player);
    }

    Team team = Team(name: _teamNameController.text, players: players);

    LocalDatabaseService.instance.createTeam(team);

    setState(() {});

    _teamNameController.text = '';
    _playerNumbersController.text = '';

    Navigator.of(context).pop();
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return AppBar(
      title: const Text('Team Auswahl'),
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back)),
      actions: [
        IconButton(
            onPressed: () {
              _showCreateTeamDialog();
            },
            icon: const Icon(Icons.add))
      ],
    );
  }
}
