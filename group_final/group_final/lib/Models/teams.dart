import 'dart:convert';

//id, team_logo, owner, team_name, points_to_date
class Team {
  final String id;
  final String team_logo;
  final String owner;
  final String team_name;
  final String points_to_date;

  Team._(
      this.id, this.team_logo, this.owner, this.team_name, this.points_to_date);

  factory Team.fromJson(Map json) {
    final id = json[''].replaceAll('ObjectId(\"', '').replaceAll('\")', '');
    final team_logo = json['team_logo'];
    final owner = json['owner'];
    final team_name = json['team_name'];
    final points_to_date = json['points_to_date'];

    return Team._(id, team_logo, owner, team_name, points_to_date);
  }
}
