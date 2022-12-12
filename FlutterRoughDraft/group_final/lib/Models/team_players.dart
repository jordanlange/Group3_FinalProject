import 'dart:convert';

class Player {
  final String id;
  final String team_player_ID;
  final String owner;
  final String QB;
  final String RB;
  final String WR1;
  final String WR2;
  final String TE;
  final String K;

  Player._(this.id, this.team_player_ID, this.owner, this.QB, this.RB, this.WR1,
      this.WR2, this.TE, this.K);

  factory Player.fromJson(Map json) {
    final id = json[''].replaceAll('ObjectId(\"', '').replaceAll('\")', '');
    final team_player_ID = json['team_player_ID'];
    final owner = json['owner'];
    final QB = json['QB'];
    final RB = json['RB'];
    final WR1 = json['WR1'];
    final WR2 = json['WR2'];
    final TE = json['TE'];
    final K = json['K'];

    return Player._(id, team_player_ID, owner, QB, RB, WR1, WR2, TE, K);
  }
}
