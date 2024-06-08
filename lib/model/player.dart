import 'package:selektion/model/rating.dart';

class Player {
  int number;
  List<Rating> ratings;
  bool isTop4;
  String note;

  Player(this.number, this.ratings, this.isTop4, this.note);

  Map<String, dynamic> toMap() {
    return {
      'number': number,
      'ratings': ratings.map((rating) => rating.index).toList(),
      'isTop4': isTop4
    };
  }

  factory Player.fromMap(Map map) {
    bool isTop4 = map['isTop4'] == 0 ? false : true;
    String note = map['note'] ?? '';
    return Player(map['number'], [], isTop4, note);
  }
}
