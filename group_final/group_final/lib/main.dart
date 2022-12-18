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

  void _deleteTeam(id) {
    setState(() {
      widget.api.deleteTeam(id);
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyHomePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 100,
          title: Text(
            ' Fantasy Football App',
            style: TextStyle(fontSize: 30),
          ),
          centerTitle: true,
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(30)))),
      body: Center(
          child: _dbLoaded
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        'Teams',
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.deepPurpleAccent,
                            decoration: TextDecoration.underline),
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
                                    child: Image.network(
                                        'https://imgprd19.hobbylobby.com/8/a1/b9/8a1b99a889c29d2963e8e050cb484c8941d4676c/700Wx700H-1607233-0120.jpg'),
                                    //Text(team['team_logo']),
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
                                      "Season Points: " +
                                          team['points_to_date'],
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ])),
                            ),
                          ),
                        ),
                        // ElevatedButton(
                        //  onPressed: () => {
                        //   _deleteTeam(widget),
                        //  },
                        //  child: Text("Add Team"),
                        //),
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
