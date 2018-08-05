params ["_ship"];
private _rel_pos = _ship worldToModelVisual getPosASLW vehicle player;
private _rel_dir = getDir vehicle player - getDir _ship;


private _pos = getPosWorld _ship;
private _velocity = _ship getVariable ["velocity", [0,0,0]];
private _yaw = 180 + getDir _ship;
(_ship call BIS_fnc_getPitchBank) params ["_pitch", "_bank"];

// anything better than diag_tickTime? (precision gets lower as game goes on).
private _dt = 1 / diag_fps;

private _engine = _ship getVariable ["engine", 0];
private _rudder = _ship getVariable ["rudder", 0];


// Thoughts:
// water resistance. increased by rudder angle
// rudder ineffective at low speed
// force is speed/engine difference
// acceleration defined by force / mass
// acceleration = speed''
// rudder has slow reaction time
// engine has medium reaction time
// find physically correct references
// steering motion?? (turning center)
// high rudder angle -> pitch
// wave impact?

// for now: speed = target speed
// rudder effect = rudder setting. turns around base object center

// maxspeed: 31knots = 16m/s

_velocity = [_engine * 16 * _dt * sin _yaw, _engine * 16 * _dt * cos _yaw, 0];
_pos = _pos vectorAdd _velocity;
_yaw = _yaw - _rudder * 0.1 * _dt * _engine;


_ship setVariable ["velocity", _velocity];

_ship setPosASL _pos;
// just one velocity for the whole thing for now
[_ship, _velocity, [_yaw+180, _pitch, _bank]] call update_pos_w_guns;
_ship setVariable ["_last_rel_pos", _rel_pos];