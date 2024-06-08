import 'package:selektion/model/player.dart';

class Team {
  final int? id;
  final String name;
  final List<Player> players;

  Team({this.id, required this.name, required this.players});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'players': players.map((player) => player.toMap()).toList(),
    };
  }

/*   factory Team.fromMapList(
      String teamName, List<Map<String, dynamic>> playerMaps) {
    List<Player> players =
        playerMaps.map((map) => Player.fromMap(map)).toList();
    return Team(teamName, players);
  } */
}
