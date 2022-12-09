// add requirements
const express = require('express');
const app = express();
const nodemon = require('nodemon');
app.use(express.json());

// Mongoose package (new this week)
const mongoose = require('mongoose');

// set port to 1200 per assignment instructions
const PORT = 1200;

// MongoDB connection string pointing to db named 'G3A4'
const dbURL = "mongodb+srv://admin:Underling999@cluster0.zkxltog.mongodb.net/G3A4";

// connect to MongoDB
mongoose.connect(dbURL,
    {
        useNewURLParser: true,
        useUnifiedTopology: true
    });

// Mongoose connection
const db = mongoose.connection;

// Handle DB error, display connection
db.on('error', () => {
    console.error.bind(console, 'connection error: ');
});
db.once('open', () => {
    console.log('MongoDB Connected');
});

// Schema model declaration
require('./Models/Team');
require('./Models/Player');
require('./Models/Team_Player');

const Team = mongoose.model('Team');
const Player = mongoose.model('Player');
const Team_player = mongoose.model('Team_Player');

// index route; proves server connection is up and running and Postman works
app.get('/', (req, res) => {
    return res.status(200).json("(message: OK)");
});

// ##############################################################################
// The ADD_TEAM route controller
// ##############################################################################
app.post('/addTeam', async (req, res) => {
    try {
        let team = {
            owner: req.body.owner,
            points_to_date: req.body.points_to_date,
            team_name: req.body.team_name,
            team_logo: req.body.team_logo
        }
        await Team(team).save().then(e => {
            return res.status(201).json('Team Added');
        })

    } catch {
        return res.status(500).json('message: failed to add team -- bad data');
    }
});


// ##############################################################################
// The ADD_TEAM_PLAYER route controller
// ##############################################################################
app.post('/addTeam_player', async (req, res) => {
    try {
        let team_player = {
            team_player_ID: req.body.team_player_ID,
            owner: req.body.owner,
            QB: req.body.QB,
            RB: req.body.RB,
            WR1: req.body.WR1,
            WR2: req.body.WR2,
            TE: req.body.TE,
            K: req.body.K
        }
        await Team_player(team_player).save().then(e => {
            return res.status(201).json('Team_player Added');
        })

    } catch {
        return res.status(500).json('message: failed to add team_player -- bad data');
    }
});


// ##############################################################################
// The EDIT_TEAM_PLAYER_BY_OWNER route controller
// ##############################################################################

app.post('/editTeam_playerByOwner', async (req, res) => {
    try {
        let team_player = await Team_player.updateOne({owner: req.body.owner}
        , {
            QB: req.body.QB,
            RB: req.body.RB,
            WR1: req.body.WR1,
            WR2: req.body.WR2,
            TE: req.body.TE,
            K: req.body.K
        }, {upsert: true});
        if(team_player)
        {
            res.status(200).json('message: Team_player roster updated');
        }
        else {
            res.status(200).json('message: No Team_player roster changes made');
        }

    } catch {
        return res.status(500).json('message: failed to edit Team_player roster');
    }
});


// ##############################################################################
// The GET_ALL_TEAMS route controller
// ##############################################################################
app.get('/getAllTeams', async (req, res) => {
    try {
        let teams = await Team.find({}).lean();
        return res.status(200).json({"teams": teams});
    } catch {
        return res.status(500).json('message: failed to get teams');
    }
});


// ##############################################################################
// The GET_ALL_TEAM_PLAYERS route controller
// ##############################################################################
app.get('/getAllTeam_players', async (req, res) => {
    try {
        let team_players = await Team_player.find({}).lean();
        return res.status(200).json(team_players);
    } catch {
        return res.status(500).json('message: failed to get team_players');
    }
});


// ##############################################################################
// The FIND_TEAM (BY TEAM NAME) route controller
// ##############################################################################
app.post('/findTeam', async (req, res) => {
    try {
    let oneTeam = {
        team_name: req.body.team_name
        }
    var result = await Team.findOne({ team_name: oneTeam.team_name });
    return res.status(200).json(result);
    } catch {
        return res.status(500).json('message: failed to find team name match');
    }
});


// ##############################################################################
// The FIND_TEAM_PLAYERS_BY_OWNER route controller
// ##############################################################################
app.post('/findTeam_player', async (req, res) => {
    try {
    let oneTeam_player = {
        owner: req.body.owner
        }
    var result = await Team_player.findOne({ owner: oneTeam_player.owner });
    return res.status(200).json(result);
    } catch {
        return res.status(500).json('message: failed to find team_player owner match');
    }
});

// ##############################################################################
// The ADD_PLAYER route controller
// ##############################################################################
app.post('/addPlayer', async (req, res) => {
    try {
        let player = {
            bye_week: req.body.bye_week,
            player_name: req.body.player_name,
            points_scored: req.body.points_scored,
            position: req.body.position,
            status: req.body.status
        }
        await Player(player).save().then(e => {
            return res.status(201).json('Player Added');
        })

    } catch {
        return res.status(500).json('message: failed to add player -- bad data');
    }
});

// ##############################################################################
// The GET_ALL_PLAYERS route controller
// ##############################################################################

app.get('/getAllPlayers', async (req, res) => {
    try {
        let players = await Player.find({}).lean();
        // return res.status(200).json(courses);
        return res.status(200).json({'players': players});
    } catch {
        return res.status(500).json('message: failed to get players');
    }
});

// ##############################################################################
// The FIND_PLAYER (BY PLAYER_NAME) route controller
// ##############################################################################
app.post('/findPlayer', async (req, res) => {
    try {
    let onePlayer = {
        player_name: req.body.player_name
        }
        var result = await Player.findOne({ player_name: onePlayer.player_name });
        return res.status(200).json(result);
    } catch {
        return res.status(500).json('message: failed to find player_name match');
    }
});


// ##############################################################################
// The EDIT_PLAYER_BY_POSITION route controller
// ##############################################################################

app.post('/editPlayerByPosition', async (req, res) => {
    try {
        var player = await Player.updateOne({player_name: req.body.player_name}
        , {
            position: req.body.position
        }, {upsert: true});
        if(player)
        {
            res.status(200).json('message: Player Position Edited');
        }
        else {
            res.status(200).json('message: No Player Position Changed');
        }

    } catch {
        return res.status(500).json('message: failed to edit player position');
    }
});


// ##############################################################################
// The EDIT_STUDENT_BY_FNAME route controller
// ##############################################################################

/*
app.post('/editStudentByFname', async (req, res) => {
    try {
        var student = await Student.updateOne({fname: req.body.queryFname}
        , {
            fname: req.body.fname,
            lname: req.body.lname
        }, {upsert: true});
        if(student)
        {
            res.status(200).json('message: Student Name Edited');
        }
        else {
            res.status(200).json('message: No Student Name Changed');
        }

    } catch {
        return res.status(500).json('message: failed to edit student name');
    }
});
*/


// ##############################################################################
// The EDIT_TEAM_NAME (BY OWNER) route controller
// ##############################################################################

app.post('/editTeam_nameByOwner', async (req, res) => {
    try {
        var team = await Team.updateOne({owner: req.body.owner}
        , {
            team_name: req.body.team_name
        }, {upsert: true});
        if(team)
        {
            res.status(200).json('message: Team Name Updated');
        }
        else {
            res.status(200).json('message: Team Name Unchanged');
        }

    } catch {
        return res.status(500).json('message: failed to update team name');
    }
});


// ##############################################################################
// The DELETE_TEAM_BY_TEAM_NAME route controller
// ##############################################################################

app.post('/deleteTeamByTeam_name', async (req, res) => {
    try {
        var team = await Team.findOne({team_name: req.body.team_name});

        if(team)
        {
            await Team.deleteOne({team_name: req.body.team_name});
            res.status(200).json('message: Team deleted.');
        }
        else {
            res.status(200).json('message: No Team found with that team_name');
        }

    } catch {
        return res.status(500).json('message: failed to delete team.');
    }
});



// ##############################################################################
// The DELETE_TEAM_PLAYER_BY_OWNER route controller
// ##############################################################################

app.post('/deleteTeam_playerByOwner', async (req, res) => {
    try {
        var team_player = await Team_player.findOne({owner: req.body.owner});

        if(team_player)
        {
            await Team_player.deleteOne({owner: req.body.owner});
            res.status(200).json('message: Team_player deleted.');
        }
        else {
            res.status(200).json('message: No Team_player found with that team_name');
        }

    } catch {
        return res.status(500).json('message: failed to delete team_player.');
    }
});


// ##############################################################################
// The DELETE_PLAYER_BY_PLAYER_NAME route controller
// ##############################################################################

app.post('/deletePlayerByPlayer_name', async (req, res) => {
    try {
        var player = await Player.findOne({player_name: req.body.player_name});

        if(player)
        {
            await Player.deleteOne({player_name: req.body.player_name});
            res.status(200).json('message: Player deleted.');
        }
        else {
            res.status(200).json('message: No Player found with that player_name');
        }

    } catch {
        return res.status(500).json('message: failed to delete player.');
    }
});


// listening in on port 1200 for any activity -- SSSSHHHHHHH!!!!
app.listen(PORT, () => {
    console.log(`Server started on port ${PORT}`);
});


