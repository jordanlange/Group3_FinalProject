import 'dart:convert';

class Player {
  final String id;
  final String bye_week;
  final String player_name;
  final String points_scored;
  final String position;
  final String status;

  Player._(this.id, this.bye_week, this.player_name, this.points_scored,
      this.position, this.status);

  factory Player.fromJson(Map json) {
    final id = json[''].replaceAll('ObjectId(\"', '').replaceAll('\")', '');
    final bye_week = json['bye_week'];
    final player_name = json['player_name'];
    final points_scored = json['points_scored'];
    final position = json['position'];
    final status = json['status'];

    return Player._(id, bye_week, player_name, points_scored, position, status);
  }
}
