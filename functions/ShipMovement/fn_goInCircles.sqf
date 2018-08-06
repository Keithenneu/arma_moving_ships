params ["_ship", "_args"];
_args params ["_angle_offset"]; // TODO: more args?

private _tt = 817;
private _t = (CBA_MissionTime % _tt);
private _a = _t/_tt*360+_angle_offset;
private _center = getMarkerPos "center";
private _r = 1300;
private _pos = [(_center select 0) + _r * cos _a, (_center select 1) + _r * sin _a, 0];
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

[_pos, _velocity, [180-_a+_xyaw, _xpitch, _xbank]]
