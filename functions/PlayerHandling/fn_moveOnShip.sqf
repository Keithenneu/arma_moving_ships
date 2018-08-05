private _objs = lineIntersectsObjs [getposasl player vectoradd [0,0,0.5], getPosASL player vectoradd [0,0,-1], objNull, objNull, false, 2+4+16];
if (count _objs == 0) exitWith {};
if (count _objs > 1) then {hintSilent "multiple objects!!"};
private _ship = (_objs select 0) getVariable ["parent_ship", objNull];
if (isNull _ship) exitWith {};
private _last_rel_pos = _ship getVariable ["_last_rel_pos", []];
if (_last_rel_pos isEqualTo []) exitWith {};
if (vehicle player == player) then {
	if (player distance _ship < 400) then // && isTouchingGround vehicle player) then
	{
		// TODO: some error detection. like tping more than a short distance
		player setPosASL (_ship modelToWorldVisualWorld _last_rel_pos);
		(player) setDir (_rel_dir + getDir _ship);
		player setVelocity [0,0,-0.4];
	};
}
else
{
	if (vehicle player distance _ship < 400 && !(vehicle player getVariable ["epe_added", false])) then {
		vehicle player addEventHandler ["EpeContact", ships_fnc_moveOnShipVehicle];
		vehicle player addEventHandler ["EpeContactEnd", ships_fnc_moveOnShipVehicle];
		vehicle player addEventHandler ["EpeContactStart", ships_fnc_moveOnShipVehicle];
		vehicle player setVariable ["epe_added", true];
	} else {
		// remove them
	};
};
