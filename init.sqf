enableSaving [false,false];

bso_epe_parts = [];

{
	private _vehicle = _x;
	{
		private _obj = _x select 0;
		bso_epe_parts pushBack _obj;
		_obj setVariable ["parent_ship", _vehicle];
	} forEach (_vehicle getVariable ["bis_carrierParts", []]);
} forEach [destroyer, carrier, carrier_straight, destroyer_free];

update_pos_w_guns = compile preprocessFileLineNumbers "update_pos_w_guns.sqf";

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

ships_pfh_proxy = {
	[carrier, 0] call bso_carrier_pfh;
	[destroyer, 180] call bso_carrier_pfh;
	[carrier_straight] call straight_carrier_pfh;
	[destroyer_free] call ships_free_driving
};

straight_carrier_pfh = {
	params ["_ship"];
	private _rel_pos = _ship worldToModelVisual getPosASLW vehicle player;
	private _tt = 817;
	private _t = (CBA_MissionTime % _tt);
	private _a = _t/_tt*4-1;
	private _direction = 1;
	if (_a > 1) then {
		_a = 2-_a;
		_direction = -1;
	};
	private _center = getMarkerPos "center";
	private _r = 1100;
	private _pos = [_center select 0, (_center select 1) + _a * _r, 0];
	_ship setPosASL _pos;
	private _xyaw = 1 * sin (_a * 40) - 1;
	private _xpitch = 1 * sin (_a * 30) - 0.5;
	private _xbank = 4 * sin (_a * 50) - 1.5;
	if (true) then { // true to disable ship rolling
		_xyaw = 0;
		_xpitch = 0;
		_xbank = 0;
	};
	private _speed = 4 * _r / _tt; // speed in m/s
	private _velocity = [0, _direction*_speed, 0];
	[_ship, _velocity, [_xyaw, _xpitch, _xbank]] call bso_update_pos;

	_ship setVariable ["_last_rel_pos", _rel_pos];
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

	_ship setVariable ["_last_rel_pos", _rel_pos];
};

[] call compile preprocessFileLineNumbers "init_freedriving.sqf";
ships_free_driving = compile preprocessFileLineNumbers "freedriving.sqf";

movement_on_ship = {
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
			vehicle player addEventHandler ["EpeContact", epe_proxy];
			vehicle player addEventHandler ["EpeContactEnd", epe_proxy];
			vehicle player addEventHandler ["EpeContactStart", epe_proxy];
			vehicle player setVariable ["epe_added", true];
		} else {
			// remove them
		};
	};
};

[{[] call ships_pfh_proxy; [] call movement_on_ship}] call CBA_fnc_addPerFrameHandler;

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