import 'dart:io';

import 'package:path/path.dart';
import 'package:selektion/model/player.dart';
import 'package:selektion/model/rating.dart';
import 'package:selektion/model/team.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class LocalDatabaseService {
  static final LocalDatabaseService _instance =
      LocalDatabaseService._internal();
  late Database _db;
  late String _dbPath;

  LocalDatabaseService._internal();

  static LocalDatabaseService get instance => _instance;

  Future<void> init() async {
    try {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();

      _dbPath = join(documentsDirectory.path, 'team_database.db');

      _db = await openDatabase(_dbPath,
          version: 2, onCreate: _onCreate, onUpgrade: _onUpgrade);
    } catch (ex) {
      print("DatabaseException: $ex");
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE teams (
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        name TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE players (
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        number INTEGER, 
        isTop4 INTEGER,
        note TEXT,
        team_id INTEGER, 
        FOREIGN KEY (team_id) REFERENCES teams (id)
      );
    ''');

    await db.execute('''
      CREATE TABLE ratings (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE player_ratings (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      player_id INTEGER,
      rating_id INTEGER,
      FOREIGN KEY (player_id) REFERENCES players (id),
      FOREIGN KEY (rating_id) REFERENCES ratings (id)
      );
    ''');

    //insert ratings in db
    await db.insert('ratings', {'name': Rating.ungenduegend.name});
    await db.insert('ratings', {'name': Rating.genuegend.name});
    await db.insert('ratings', {'name': Rating.gut.name});
    await db.insert('ratings', {'name': Rating.sehrgut.name});
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print('upgrade db');
    if (oldVersion < 2) {
      await db.execute('''
        ALTER TABLE players ADD COLUMN note TEXT
      ''');
    }
  }

  Future<void> createTeam(Team team) async {
    await _db.transaction((txn) async {
      var teamId = await txn
          .rawInsert('INSERT INTO teams(name) VALUES (?)', [team.name]);
      for (var player in team.players) {
        var playerId = await txn.rawInsert(
            'INSERT INTO players(number, isTop4, team_id) VALUES (?, ?, ?)',
            [player.number, player.isTop4 ? 1 : 0, teamId]);
        for (var rating in player.ratings) {
          var ratingId = await txn.rawInsert(
              'INSERT OR IGNORE INTO ratings(name) VALUES (?)', [rating.name]);
          await txn.rawInsert(
              'INSERT INTO player_ratings(player_id, rating_id) VALUES (?, ?)',
              [playerId, ratingId]);
        }
      }
    });
  }

  Future<void> deletePlayer(int teamId, Player player) async {}

  Future<void> ratePlayer(
      int teamId, int playerNumber, String ratingName) async {
    // get player id
    List<Map<String, dynamic>> playerResults = await _db.query(
      'players',
      where: 'team_id = ? AND number = ?',
      whereArgs: [teamId, playerNumber],
      limit: 1,
    );

    if (playerResults.isEmpty) {
      throw Exception('player-not-found');
    }

    int playerId = playerResults.first['id'];

    // get rating id
    List<Map<String, dynamic>> ratingResults = await _db.query(
      'ratings',
      where: 'name = ?',
      whereArgs: [ratingName],
      limit: 1,
    );

    if (ratingResults.isEmpty) {
      throw Exception('rating-not-found');
    }

    int ratingId = ratingResults.first['id'];

    //add rating to player
    await _db.insert(
      'player_ratings',
      {'player_id': playerId, 'rating_id': ratingId},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> toggleIsTop4(int teamId, int playerNumber) async {
    List<Map> results = await _db.query(
      'players',
      columns: ['isTop4'],
      where: 'team_id = ? AND number = ?',
      whereArgs: [teamId, playerNumber],
    );

    if (results.isNotEmpty) {
      final currentIsTop4 = results.first['isTop4'] as int;

      final newIsTop4 = currentIsTop4 == 0 ? 1 : 0;

      await _db.update(
        'players',
        {'isTop4': newIsTop4},
        where: 'team_id = ? AND number = ?',
        whereArgs: [teamId, playerNumber],
      );
    }
  }

  Future<void> addNoteToPlayer(
      int teamId, int playerNumber, String note) async {
    await _db.update(
      'players',
      {'note': note},
      where: 'team_id = ? AND number = ?',
      whereArgs: [teamId, playerNumber],
    );
  }

  Future<List<Player>> getAllTop4Players() async {
    const String sql = '''
    SELECT *
    FROM players
    WHERE isTop4 == 1
    ''';

    final List<Map<String, dynamic>> result = await _db.rawQuery(sql);

    List<Player> returnList = [];

    for (var data in result) {
      returnList.add(Player.fromMap(data));
    }

    return returnList;
  }

  Future<List<Team>> getAllTeams() async {
    print(await _db.rawQuery('PRAGMA table_info("players")'));

    const String sql = '''
    SELECT teams.id AS TeamId, teams.name AS TeamName, players.id AS PlayerId, players.number AS PlayerNumber, players.isTop4 AS IsTop4, players.note as PlayerNote, ratings.name AS RatingName
    FROM teams
    JOIN players ON teams.id = players.team_id
    LEFT JOIN player_ratings ON players.id = player_ratings.player_id
    LEFT JOIN ratings ON player_ratings.rating_id = ratings.id
    ORDER BY teams.name, players.number;
    ''';

    final List<Map<String, dynamic>> result = await _db.rawQuery(sql);

    Map<int, Map<String, Map<int, Player>>> testMap2 = {};

    List<Team> returnList = [];

    for (var data in result) {
      int playerId = data['PlayerId'] as int;
      int playerNumber = data['PlayerNumber'] as int;
      String playerNote =
          data['PlayerNote'] != null ? data['PlayerNote'] as String : '';
      bool isTop4 = (data['IsTop4'] as int) == 1;
      int teamId = data['TeamId'] as int;
      String teamName = data['TeamName'] as String;
      String? ratingName = data['RatingName'] as String?;

      Player player = Player(playerNumber, [], isTop4, playerNote);

      if (!testMap2.containsKey(teamId)) {
        testMap2[teamId] = {teamName: {}};
      }

      Map<int, Player> players = testMap2[teamId]![teamName]!;

      if (players.containsKey(playerId)) {
        if (ratingName != null) {
          Rating rating = Rating.values.byName(ratingName);
          players[playerId]!.ratings.add(rating);
        }
      } else {
        if (ratingName != null) {
          Rating rating = Rating.values.byName(ratingName);
          player.ratings.add(rating);
        }
        players[playerId] = player;
      }

      testMap2[teamId]![teamName]!.addAll(players);
    }

    testMap2.forEach(
      (key, value) {
        returnList.add(Team(
            id: key,
            name: value.keys.toList().join(', '),
            players: value.values.first.values.toList()));
      },
    );

    return returnList;
  }

  Future<void> deleteEverything() async {
    await _db.rawDelete('DELETE FROM players');
    await _db.rawDelete('DELETE FROM teams');
    await _db.rawDelete('DELETE FROM player_ratings');
    //await _db.rawDelete('DELETE FROM rating');
  }

  Future<void> deleteDb() async {
    await deleteDatabase(_dbPath);
  }
}
