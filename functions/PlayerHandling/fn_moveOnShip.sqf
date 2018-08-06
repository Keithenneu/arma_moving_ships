private _lower = getPosASL vehicle player;
_lower set [2, 0];
private _objs = lineIntersectsObjs [getposasl vehicle player vectoradd [0,0,0.5], _lower, objNull, objNull, false, 2+4+16];
if (count _objs == 0) exitWith {};
if (count _objs > 1) then {hintSilent "multiple objects!!"};
private _ship = (_objs select 0) getVariable ["parent_ship", objNull];
if (isNull _ship) exitWith {};
if (player == vehicle player) then
{
	private _last_rel_pos = _ship getVariable ["_last_rel_pos", []];
	private _last_rel_dir = _ship getVariable ["_last_rel_dir", 0];
	if (_last_rel_pos isEqualTo []) exitWith {};
	// TODO: some error detection. like tping more than a short distance
	player setPosASL (_ship modelToWorldVisualWorld _last_rel_pos);
	player setDir (_last_rel_dir + getDir _ship);
	hintSilent str velocity player;
	if (isTouchingGround player) then
	{
		player setVelocity [0,0,-0.4];
	} else {
		player setVelocity [0,0,-2];
	};
}
else
{
	if (!(vehicle player getVariable ["epe_added", false])) then {
		vehicle player addEventHandler ["EpeContact", ships_fnc_moveOnShipVehicle];
		vehicle player addEventHandler ["EpeContactEnd", ships_fnc_moveOnShipVehicle];
		vehicle player addEventHandler ["EpeContactStart", ships_fnc_moveOnShipVehicle];
		vehicle player setVariable ["epe_added", true];
	};
};
