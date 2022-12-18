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

  TextEditingController pointsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.player_name + ' has : ' + widget.points_scored + ' points.'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Text(
                    "Enter the score for " + widget.player_name,
                    style: TextStyle(fontSize: 15),
                  ),
                  TextFormField(
                    controller: pointsController,
                  ),
                  ElevatedButton(
                    onPressed: () => {
                      _changePlayerPointTotal(
                          widget.player_name, pointsController.text),
                    },
                    child: Text("Enter Points Scored"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
