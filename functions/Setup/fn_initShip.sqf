params ["_ship", "_behaviour_func", "_args"];

{
	private _obj = _x select 0;
	ships_epe_parts pushBack _obj;
	_obj setVariable ["parent_ship", _ship];
} forEach (_ship getVariable ["bis_carrierParts", []]);

ships_known_ships pushBack [_ship, _behaviour_func, _args];
