import 'package:dio/dio.dart';
import 'package:group_final/editTeam_Player.dart';

import './Models/teams.dart';
import './Models/players.dart';

const String localhost = "http://10.0.2.2:1200/";

class FantasyAPI {
  final _dio = Dio(BaseOptions(baseUrl: localhost));

  Future<List> getAllTeams() async {
    final response = await _dio.get('/getAllTeams');

    return response.data['teams'];
  }

  Future<List> getAllPlayers() async {
    final response = await _dio.get('/getAllPlayers');

    return response.data['players'];
  }

  Future<List> getAllTeam_Players() async {
    final response = await _dio.get('/getAllTeam_players');

    return response.data['team_players'];
  }

  findTeam_player(String owner, String team_player_ID, String QB, String RB,
      String WR1, String WR2, String TE, String K) async {
    final response = await _dio.post('/findTeam_player', data: {
      'owner': owner,
      'team_player_ID': team_player_ID,
      'QB': QB,
      'RB': RB,
      'WR1': WR1,
      'WR2': WR2,
      'TE': TE,
      'K': K
    });

    return response;
  }

  Future editTeam_Player(String QB, String RB, String WR1, String WR2,
      String TE, String K, String owner) async {
    final response = await _dio.post('/editTeam_playerByOwner', data: {
      'QB': QB,
      'RB': RB,
      'WR1': WR1,
      'WR2': WR2,
      'TE': TE,
      'K': K,
      'owner': owner
    });
    return response.data;
  }

  Future editTeam(String team_name, String owner) async {
    final response = await _dio.post('/editTeam_nameByOwner',
        data: {'team_name': team_name, 'owner': owner});
    return response.data;
  }

  Future editPlayer(String id, String position) async {
    final response = await _dio
        .post('/editPlayerByPosition', data: {'id': id, 'position': position});
    return response.data;
  }

  Future deleteTeam(String id) async {
    final response =
        await _dio.post('/deleteTeamByTeam_name', data: {'id': id});
  }
}
