import 'dart:convert';

class Player {
  final String id;
  final String position;
  final String status;
  final String byeWeek;
  final String playerName;
  final String pointsScored;

  Player._(this.id, this.position, this.status, this.byeWeek, this.playerName,
      this.pointsScored);

  factory Player.fromJson(Map json) {
    final id = json[''].replaceAll('ObjectId(\"', '').replaceAll('\")', '');
    final position = json['position'];
    final status = json['status'];
    final byeWeek = json['byeWeek'];
    final playerName = json['position'];
    final pointsScored = json['status'];

    return Player._(id, position, status, byeWeek, playerName, pointsScored);
  }
}
