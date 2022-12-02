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

const Team = mongoose.model('Team');
const Player = mongoose.model('Player');

// index route; proves server connection is up and running and Postman works
app.get('/', (req, res) => {
    return res.status(200).json("(message: OK)");
});

// ##############################################################################
// The ADD_TEAM route contoller
// ##############################################################################
app.post('/addTeam', async (req, res) => {
    try {
        let team = {
            K: req.body.K,
            QB: req.body.QB,
            RB: req.body.RB,
            TE: req.body.TE,
            WR1: req.body.WR1,
            WR2: req.body.WR2,
            owner: req.body.owner,
            points_to_date: req.body.points_to_date,
            team_defense: req.body.team_defense,
            team_name: req.body.team_name
        }
        await Team(team).save().then(e => {
            return res.status(201).json('Team Added');
        })

    } catch {
        return res.status(500).json('message: failed to add team -- bad data');
    }
});

// ##############################################################################
// The GET_ALL_TEAMS route contoller
// ##############################################################################
app.get('/getAllTeams', async (req, res) => {
    try {
        let teams = await Team.find({}).lean();
        return res.status(200).json(teams);
    } catch {
        return res.status(500).json('message: failed to get teams');
    }
});

// ##############################################################################
// The FIND_TEAM (BY TEAM NAME) route contoller
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
// The ADD_PLAYER route contoller
// ##############################################################################
app.post('/addPlayer', async (req, res) => {
    try {
        let player = {
            games_played: req.body.games_played,
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
// The GET_ALL_PLAYERS route contoller
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
// The FIND_PLAYER (BY PLAYER_NAME) route contoller
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
// The EDIT_PLAYER_BY_POSITION route contoller
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
// The EDIT_STUDENT_BY_FNAME route contoller
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
// The EDIT_OWNER_BY_TEAM route contoller
// ##############################################################################

app.post('/editOwnerByTeam', async (req, res) => {
    try {
        var team = await Team.updateOne({team_name: req.body.team_name}
        , {
            owner: req.body.owner
        }, {upsert: true});
        if(team)
        {
            res.status(200).json('message: Team Owner Updated');
        }
        else {
            res.status(200).json('message: Team Owner Unchanged');
        }

    } catch {
        return res.status(500).json('message: failed to update team owner');
    }
});


// ##############################################################################
// The DELETE_TEAM_BY_TEAM_NAME route contoller
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
// The DELETE_PLAYER_BY_PLAYER_NAME route contoller
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


