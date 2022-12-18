import 'package:flutter/material.dart';
import 'package:group_final/api.dart';
import 'package:group_final/editTeam_Player.dart';
import 'package:group_final/main.dart';

class editTeam extends StatefulWidget {
  final String id, team_logo, owner, team_name, points_to_date;
  final FantasyAPI api = FantasyAPI();

  editTeam(
      this.id, this.team_logo, this.owner, this.team_name, this.points_to_date);

  @override
  State<editTeam> createState() =>
      _editTeamState(id, team_logo, owner, team_name, points_to_date);
}

class _editTeamState extends State<editTeam> {
  final String id, team_logo, owner, team_name, points_to_date;

  _editTeamState(
      this.id, this.team_logo, this.owner, this.team_name, this.points_to_date);

  void _changeteam_logo(points_to_date, team_logo) {
    setState(() {
      widget.api.editTeam(points_to_date, team_logo);
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyHomePage()));
    });
  }

  void _deleteTeam(team_name) {
    setState(() {
      widget.api.deleteTeam(team_name);
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyHomePage()));
    });
  }

  List team_players = [];
  bool _dbLoaded = false;

  void initState() {
    super.initState();

    widget.api.getAllTeam_Players().then((data) {
      setState(() {
        team_players = data;
        _dbLoaded = true;
      });
    });
  }

  TextEditingController ownerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.owner),
      ),
      body: Center(
          child: _dbLoaded
              ? Column(
                  children: [
                    Expanded(
                        child: ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.all(15.0),
                      children: [
                        ElevatedButton(
                          onPressed: () => {
                            _deleteTeam(widget.team_name),
                          },
                          child: Text("Delete Team: " + widget.team_name),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Text(
                            'Teams in the League',
                            style: TextStyle(
                                fontSize: 30, color: Colors.deepPurpleAccent),
                          ),
                        ),
                        ...team_players.map<Widget>(
                          (team_player) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            child: TextButton(
                              onPressed: () => {
                                Navigator.pop(context),
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => editTeam_Player(
                                            team_player['_id'],
                                            team_player['team_player_ID'],
                                            team_player['owner'],
                                            team_player['QB'],
                                            team_player['RB'],
                                            team_player['WR1'],
                                            team_player['WR2'],
                                            team_player['TE'],
                                            team_player['K']))),
                              },
                              child: ListTile(
                                  leading: CircleAvatar(
                                    radius: 30,
                                    child: Text(team_player['owner']),
                                  ),
                                  title: Column(children: <Widget>[
                                    Text(
                                      team_player['owner'],
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Text(
                                      "QB: " + team_player['QB'],
                                      style: TextStyle(fontSize: 10),
                                    ),
                                    Text(
                                      "RB: " + team_player['RB'],
                                      style: TextStyle(fontSize: 10),
                                    ),
                                    Text(
                                      "WR1: " + team_player['WR1'],
                                      style: TextStyle(fontSize: 10),
                                    ),
                                    Text(
                                      "WR2: " + team_player['WR2'],
                                      style: TextStyle(fontSize: 10),
                                    ),
                                    Text(
                                      "TE: " + team_player['TE'],
                                      style: TextStyle(fontSize: 10),
                                    ),
                                    Text(
                                      "K: " + team_player['K'],
                                      style: TextStyle(fontSize: 10),
                                    )
                                  ])),
                            ),
                          ),
                        ),
                      ],
                    )),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Database Loading",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    CircularProgressIndicator()
                  ],
                )),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.home),
          onPressed: () => {
                Navigator.pop(context),
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyHomePage())),
              }),
    );
  }
}
