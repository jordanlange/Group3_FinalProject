import 'package:dio/dio.dart';

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
