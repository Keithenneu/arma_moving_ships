{
	_x params ["_ship", "_movement_func", ["_args", []]];
	private _rel_pos = _ship worldToModelVisual getPosASLW vehicle player;
	private _new_state = [_ship, _args] call _movement_func;
	[_ship, _new_state] call ships_fnc_updatePosition;
	_ship setVariable ["_last_rel_pos", _rel_pos];
} forEach ships_known_ships;
[] call ships_fnc_moveOnShip;
