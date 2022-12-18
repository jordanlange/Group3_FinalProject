import 'package:flutter/material.dart';
import 'package:group_final/api.dart';
import 'package:group_final/main.dart';

class editPlayer extends StatefulWidget {
  final String id, bye_week, player_name, points_scored, position, status;
  final FantasyAPI api = FantasyAPI();

  editPlayer(this.id, this.bye_week, this.player_name, this.points_scored,
      this.position, this.status);

  @override
  State<editPlayer> createState() => _editPlayerState(
      id, bye_week, player_name, points_scored, position, status);
}

class _editPlayerState extends State<editPlayer> {
  final String id, bye_week, player_name, points_scored, position, status;

  _editPlayerState(this.id, this.bye_week, this.player_name, this.points_scored,
      this.position, this.status);

  void _changePlayerPointTotal(player_name, points_scored) {
    setState(() {
      widget.api.editPlayerPoints(player_name, points_scored);
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
        title: Text(widget.player_name),
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
                            _changePlayerPointTotal(
                                widget.player_name, widget.points_scored),
                          },
                          child: Text("Delete Current Team "),
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
