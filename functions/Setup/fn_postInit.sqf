[{[] call ships_fnc_handleShips}] call CBA_fnc_addPerFrameHandler;

[] call ships_fnc_onRespawn;
player addEventHandler ["Respawn",{ [] call ships_fnc_onRespawn}];
