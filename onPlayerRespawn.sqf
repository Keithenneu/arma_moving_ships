player addAction ["TP Pad (destroyer going in circles)", {player setposasl (destroyer modelToWorldWorld [0,75,8.75])}];
player addAction ["TP Bridge (destroyer going in circles)", {player setposasl (destroyer modelToWorldWorld [0,-36,19.5])}];
player addAction ["TP Deck (carrier going in circles)", {player setposasl (carrier modelToWorldWorld [0,0,22.5])}];

player addAction ["TP Pad (free driving)", {player setposasl (destroyer_free modelToWorldWorld [0,75,8.75])}];
player addAction ["TP Bridge (free driving)", {player setposasl (destroyer_free modelToWorldWorld [0,-36,19.5])}];
player addAction ["TP Bow (free driving)", {player setposasl (destroyer_free modelToWorldWorld [0,-106,12.75])}];