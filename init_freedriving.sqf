private _ship = destroyer_free;
private _side = west;

private _weapons = 
[["B_Ship_Gun_01_F",[0,-78,14.8321],180],
["B_Ship_MRLS_01_F",[0,-62.4,11.9231],180],
["B_AAA_System_01_F",[0,-47.9,17.5332],180],
["B_AAA_System_01_F",[0,35.9,21.7476],0],
["B_SAM_System_01_F",[0,50.6,17.5499],180]];


private _guns = [];

{
	_x params ["_vehicleclass", "_position_rel", "_dir_rel"];
	private _grp = createGroup _side;
	private _gun = createVehicle [_vehicleclass, asltoatl (_ship modelToWorldWorld _position_rel), [], 0, "CAN_COLLIDE"];
	_gun setDir (getDir _ship + _dir_rel);
	_gun setPosWorld (_ship modelToWorldWorld _position_rel);
	createvehiclecrew _gun;
	private _crew = crew _gun;
	_crew joinsilent _grp;
	_grp addVehicle _gun;
	_guns pushBack [format ["gun_%1", _foreachIndex], _gun, _position_rel, _dir_rel];
} forEach _weapons;

_ship setVariable ["guns", _guns];


player addAction ["Flank Speed", {destroyer_free setVariable ["engine", 1.2]}];
player addAction ["Full Ahead", {destroyer_free setVariable ["engine", 1]}];
player addAction ["Half Ahead", {destroyer_free setVariable ["engine", 0.5]}];
player addAction ["Slow Ahead", {destroyer_free setVariable ["engine", 0.15]}];
player addAction ["Stop", {destroyer_free setVariable ["engine", "0"]}];
player addAction ["Slow Astern", {destroyer_free setVariable ["engine", -0.075]}]; // halved for backwards. no idea.
player addAction ["Half Astern", {destroyer_free setVariable ["engine", -0.25]}];
player addAction ["Full Astern", {destroyer_free setVariable ["engine", -0.5]}];

player addAction ["30° port", {destroyer_free setVariable ["rudder", 30]}];
player addAction ["20° port", {destroyer_free setVariable ["rudder", 20]}];
player addAction ["10° port", {destroyer_free setVariable ["rudder", 10]}];
player addAction ["dead ahead", {destroyer_free setVariable ["rudder", 0]}];
player addAction ["10° starboard", {destroyer_free setVariable ["rudder", -10]}];
player addAction ["20° starboard", {destroyer_free setVariable ["rudder", -20]}];
player addAction ["30° starboard", {destroyer_free setVariable ["rudder", -30]}];