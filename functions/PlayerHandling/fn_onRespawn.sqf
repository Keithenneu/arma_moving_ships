player addAction ["TP Pad (destroyer going in circles)", {player setposasl (destroyer modelToWorldWorld [0,75,8.75])}];
player addAction ["TP Bridge (destroyer going in circles)", {player setposasl (destroyer modelToWorldWorld [0,-36,19.5])}];
player addAction ["TP Deck (carrier going in circles)", {player setposasl (carrier modelToWorldWorld [0,0,22.5])}];

player addAction ["TP Pad (free driving)", {player setposasl (destroyer_free modelToWorldWorld [0,75,8.75])}];
player addAction ["TP Bridge (free driving)", {player setposasl (destroyer_free modelToWorldWorld [-3.5,-42,19.1])}];
player addAction ["TP Bow (free driving)", {player setposasl (destroyer_free modelToWorldWorld [0,-106,12.75])}];



// TODO: wrong file
player addAction ["Flank Speed", {destroyer_free setVariable ["engine", 1]}];
player addAction ["Full Ahead", {destroyer_free setVariable ["engine", 0.66]}];
player addAction ["Half Ahead", {destroyer_free setVariable ["engine", 0.33]}];
player addAction ["Slow Ahead", {destroyer_free setVariable ["engine", 0.1]}];
player addAction ["Stop", {destroyer_free setVariable ["engine", 0]}];
player addAction ["Slow Astern", {destroyer_free setVariable ["engine", -0.1]}]; // halved for backwards. no idea.
player addAction ["Half Astern", {destroyer_free setVariable ["engine", -0.33]}];
player addAction ["Full Astern", {destroyer_free setVariable ["engine", -0.66]}];

player addAction ["30° port", {destroyer_free setVariable ["rudder", 30]}];
player addAction ["20° port", {destroyer_free setVariable ["rudder", 20]}];
player addAction ["10° port", {destroyer_free setVariable ["rudder", 10]}];
player addAction ["dead ahead", {destroyer_free setVariable ["rudder", 0]}];
player addAction ["10° starboard", {destroyer_free setVariable ["rudder", -10]}];
player addAction ["20° starboard", {destroyer_free setVariable ["rudder", -20]}];
player addAction ["30° starboard", {destroyer_free setVariable ["rudder", -30]}];


//player addEventHandler ["Respawn",{ [] call ships_fnc_onRespawn}];
