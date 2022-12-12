import 'package:flutter/material.dart';
import 'package:group_final/api.dart';
import 'package:group_final/editPlayer.dart';
import 'package:group_final/main.dart';

class editTeam_Player extends StatefulWidget {
  final String id, team_player_ID, owner, QB, RB, WR1, WR2, TE, K;
  final FantasyAPI api = FantasyAPI();

  editTeam_Player(this.id, this.team_player_ID, this.owner, this.QB, this.RB,
      this.WR1, this.WR2, this.TE, this.K);

  @override
  State<editTeam_Player> createState() =>
      _editTeam_PlayerState(id, team_player_ID, owner, QB, RB, WR1, WR2, TE, K);
}

class _editTeam_PlayerState extends State<editTeam_Player> {
  final String id, team_player_ID, owner, QB, RB, WR1, WR2, TE, K;

  _editTeam_PlayerState(this.id, this.team_player_ID, this.owner, this.QB,
      this.RB, this.WR1, this.WR2, this.TE, this.K);

  //void _changeteam_logo(points_to_date, team_logo) {
  //  setState(() {
  //    widget.api.editTeam_Player(points_to_date, team_logo);
  //    Navigator.pop(context);
  //   Navigator.push(
  //       context, MaterialPageRoute(builder: (context) => MyHomePage()));
  // });
  //}

  void _deleteTeam(id) {
    setState(() {
      widget.api.deleteTeam(id);
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyHomePage()));
    });
  }

  List players = [];
  bool _dbLoaded = false;

  void initState() {
    super.initState();

    widget.api.getAllPlayers().then((data) {
      setState(() {
        players = data;
        data.sort((a, b) {
          return a['player_name']
              .toLowerCase()
              .compareTo(b['player_name'].toLowerCase());
        });
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
                            _deleteTeam(widget.id),
                          },
                          child: Text("Delete Team"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Text(
                            'Player List',
                            style: TextStyle(
                                fontSize: 30, color: Colors.deepPurpleAccent),
                          ),
                        ),
                        ...players.map<Widget>(
                          (player) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            child: TextButton(
                              onPressed: () => {
                                Navigator.pop(context),
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => editPlayer(
                                            player['_id'],
                                            player['bye_week'],
                                            player['player_name'],
                                            player['points_scored'],
                                            player['position'],
                                            player['status']))),
                              },
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 30,
                                  child: Text(player['position']),
                                ),
                                title: Text(
                                  player['player_name'],
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                        )
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
