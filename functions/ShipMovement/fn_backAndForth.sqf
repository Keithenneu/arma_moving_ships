params ["_ship", "_args"];

// TODO: args
private _tt = 400;
private _t = (CBA_MissionTime % _tt);
private _a = _t/_tt*4-1;
private _direction = 1;
if (_a > 1) then {
	_a = 2-_a;
	_direction = -1;
};
private _center = getMarkerPos "center";
private _r = 1000;
private _pos = [_center select 0, (_center select 1) + _a * _r, 0];
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

[_pos, _velocity, [_xyaw, _xpitch, _xbank]]
