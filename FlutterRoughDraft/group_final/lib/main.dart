import 'package:flutter/material.dart';
import 'package:group_final/editPlayer.dart';
import 'package:group_final/editTeam.dart';
import 'api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fantasy App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final FantasyAPI api = FantasyAPI();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List teams = [];
  bool _dbLoaded = false;

  void initState() {
    super.initState();

    widget.api.getAllTeams().then((data) {
      setState(() {
        teams = data;
        data.sort((a, b) {
          return a['team_name']
              .toLowerCase()
              .compareTo(b['team_name'].toLowerCase());
        });
        _dbLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' Fantasy App'),
      ),
      body: Center(
          child: _dbLoaded
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        'Teams',
                        style: TextStyle(
                            fontSize: 30, color: Colors.deepPurpleAccent),
                      ),
                    ),
                    Expanded(
                        child: ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.all(15.0),
                      children: [
                        ...teams.map<Widget>(
                          (team) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            child: TextButton(
                              onPressed: () => {
                                Navigator.pop(context),
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => editTeam(
                                            team['_id'],
                                            team['team_logo'],
                                            team['owner'],
                                            team['team_name'],
                                            team['points_to_date']))),
                              },
                              child: ListTile(
                                  leading: CircleAvatar(
                                    radius: 50,
                                    child: Text(team['team_logo']),
                                  ),
                                  title: Column(children: <Widget>[
                                    Text(
                                      team['team_name'],
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Text(
                                      team['owner'],
                                      style: TextStyle(fontSize: 10),
                                    ),
                                    Text(
                                      team['points_to_date'],
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ])),
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
    );
  }
}
