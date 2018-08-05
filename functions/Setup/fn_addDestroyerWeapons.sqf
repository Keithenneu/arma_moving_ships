params ["_ship", ["_side", west]];

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
