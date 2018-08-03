enableSaving [false,false];

bso_epe_parts = [];

{
	private _vehicle = _x;
	{
		bso_epe_parts pushBack (_x select 0);
	} forEach (_vehicle getVariable ["bis_carrierParts", []]);
} forEach [destroyer, carrier];

bso_update_pos = {
	params ["_carrierBase", "_velocity", "_rotation"];
	_rotation params ["_yaw", "_pitch", "_bank"];

	_carrierBase setVelocity _velocity;
	private _carrierPartsArray = _carrierBase getVariable ["bis_carrierParts", []];

	_carrierBase setDir _yaw;
	[_carrierBase, _pitch, _bank] call BIS_fnc_setPitchBank;

	{
		_dummy = _x select 0;
		_dummy setDir _yaw;
		[_dummy, _pitch, _bank] call BIS_fnc_setPitchBank;
		_carrierPartPos = _carrierBase modelToWorldWorld (_carrierBase selectionPosition (_x select 1));
		_dummy setPosWorld _carrierPartPos;
		_dummy setVelocity _velocity;

	} foreach _carrierPartsArray;
};

bso_both_ships = {
	[carrier, 0] call bso_carrier_pfh;
	[destroyer, 180] call bso_carrier_pfh;
};

bso_carrier_pfh =
{
	params ["_ship", "_angle_offset"];
	private _rel_pos = _ship worldToModelVisual getPosASLW vehicle player;
	private _rel_dir = getDir vehicle player - getDir _ship;
	private _tt = 817;
	private _t = (CBA_MissionTime % _tt);
	private _a = _t/_tt*360+_angle_offset;
	private _center = getMarkerPos "center";
	private _r = 1300;
	private _pos = [(_center select 0) + _r * cos _a, (_center select 1) + _r * sin _a, 0];
	_ship setPosASL _pos;
	private _xyaw = 1 * sin (_a * 40) - 1;
	private _xpitch = 1 * sin (_a * 30) - 0.5;
	private _xbank = 4 * sin (_a * 50) - 1.5;
	if (false) then { // true to disable ship rolling
		_xyaw = 0;
		_xpitch = 0;
		_xbank = 0;
	};
	private _speed = 3.141692654 * 2 * _r / _tt; // speed in m/s
	// just one velocity for the whole thing for now
	private _velocity = [-_speed * sin _a, _speed * cos _a, 0];
	[_ship, _velocity, [180-_a+_xyaw, _xpitch, _xbank]] call bso_update_pos;

	if (vehicle player == player) then {
		// TODO: do some check if actually on the boat
		if (player distance _ship < 400) then // && isTouchingGround vehicle player) then
		{
			player setPosASL (_ship modelToWorldVisualWorld _rel_pos);
			(player) setDir (_rel_dir + getDir _ship);
			player setVelocity [0,0,-0.4];
		};
	}
	else
	{
		if (vehicle player distance _ship < 400 && !(vehicle player getVariable ["epe_added", false])) then {
			vehicle player addEventHandler ["EpeContact", epe_proxy];
			vehicle player addEventHandler ["EpeContactEnd", epe_proxy];
			vehicle player addEventHandler ["EpeContactStart", epe_proxy];
			vehicle player setVariable ["epe_added", true];
		} else {
			// remove them
		};
	};
};

[{_this call bso_both_ships}] call CBA_fnc_addPerFrameHandler;

epe_proxy = {
	_this call epe_handler;
};

// TODO: find better way of doing it
epe_handler = {
	params ["_helo", "_obj"];
	private _force = _this select 4;
	if (_obj in bso_epe_parts) then {
		private _force = (_this select 4) / (getMass _helo / 200); // idle force is roughly weight / 200
		_force = (0 max _force) min 1;
		hintSilent str _force;
		private _v_pad = velocity _obj;
		private _v_helo = velocity _helo;
		private _v_res = _v_helo vectorMultiply (1 - _force) vectorAdd (_v_pad vectorMultiply _force);
		_helo setVelocity _v_res;
	};
};