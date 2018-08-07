params ["_ship", "_args"];

// TODO: args?
private _pos = getPosWorld _ship vectorAdd [0,0,0.5];
private _velocity = _ship getVariable ["velocity", [0,0,0]];
private _yaw = 180 + getDir _ship;
(_ship call BIS_fnc_getPitchBank) params ["_pitch", "_bank"];

// anything better than diag_tickTime? (precision gets lower as game goes on).
private _dt = 1 / diag_fps;

private _target_engine = _ship getVariable ["engine", 0];
private _target_rudder = _ship getVariable ["rudder", 0];


// Thoughts:
// water resistance. increased by rudder angle
// rudder ineffective at low speed
// force is speed/engine difference
// acceleration defined by force / mass
// acceleration = speed''
// rudder reaction time
// engine reaction time
// find physically correct references
// steering motion?? (turning center)
// high rudder angle -> pitch
// wave impact?

// Stuff roughly based on Arleigh Burk-Class
// wikipedia:
// power: 100.000 horse power (~80.000kW)
// max speed: 31knots (~16m/s)
// Tonnage: ~8800 tons (8.800.000kg)
// based on that:
// drag (assuming optimal efficiency, speed quadratic)
// maxpower = force * maxspeed = (drag * maxspeed^2) * maxspeed = drag * maxspeed^3
// -> drag = maxpower / maxspeed^3 = 80.000*10^3(kg*m^2/s^3) / 16^3 (m^3/s^3) = 19.5*10^3 kg/m

private _debug = [];

#define MAX_SPEED 16
#define ENGINE_CHANGE_TIME 4
#define RUDDER_CHANGE_TIME 10
#define MAX_RUDDER 30
#define STREAM_FORCE_FACTOR 1000
// -kN at full rudder and maxspeed
#define RUDDER_DRAG 20
#define WEIGHT 8800
#define DRAG 19.5


// TODO: boat is a bit too nimble imo

// TODO: those values are bs.
// 15knots(~8m/s),500m radius(half circ. 1570m) -> 180° <=> 196s (eff= 26.4) -> X * 26.4 = 1.09° / s -> X = 0.0412
#define RUDDER_FACTOR 0.0412
// rudder bites at 5knots(2.6ms)
#define RUDDER_MIN_SPEED 2.6

private _cur_engine = _ship getVariable ["cur_engine", 0];
private _diff_engine = _target_engine - _cur_engine;
if (abs _diff_engine > _dt / ENGINE_CHANGE_TIME) then { _diff_engine = (_dt / ENGINE_CHANGE_TIME) * (_diff_engine / abs _diff_engine ) };
private _engine = _cur_engine + _diff_engine;
_debug pushBack ["engine", _engine];


// rudder:
// some old af battleship had -30° to 30°. should be good enough, at it's more for reference here
// rudder speed:
// random value: 10sec -30° to 30°
private _cur_rudder = _ship getVariable ["cur_rudder", 0];
private _diff_rudder = _target_rudder - _cur_rudder;
if (abs _diff_rudder > 2 * MAX_RUDDER * _dt / RUDDER_CHANGE_TIME) then { _diff_rudder = (2 * MAX_RUDDER * _dt / RUDDER_CHANGE_TIME) / (_diff_rudder / abs _diff_rudder )  };
private _rudder = _cur_rudder + _diff_rudder;
_debug pushBack ["rudder", _rudder];

// boat back is front. w00t
private _cur_speed = -(velocityModelSpace _ship select 1);

// drag
private _drag = - DRAG * _cur_speed * _cur_speed;
if (_cur_speed < 0) then { _drag = -2*_drag }; // back ward drag is higher. assuming 2 times for now

_debug pushBack ["drag", _drag];
private _totalforces = _drag;

// rudder drag
// linear with sin rudder(degree)

private _rudder_drag_force = abs sin _rudder * 2 * RUDDER_DRAG * _cur_speed * _cur_speed;
if (_cur_speed > 0) then { _rudder_drag_force = -_rudder_drag_force};

_debug pushBack ["rudder_drag", _rudder_drag_force];
_totalforces = _totalforces + _rudder_drag_force;

// engine:
// assume propulsion system emits water stream sufficient for holding desired speed
// acceleration force is based on the difference of that stream to ship speed
// but cant exceed engine power
// TODO: engine power changing takes time

private _target_speed = _cur_engine * MAX_SPEED;
private _diff_speed = _target_speed - _cur_speed;

private _engine_force = if (_diff_speed > 0) then {_diff_speed*_diff_speed} else {-_diff_speed*_diff_speed};
private _engine_force = _engine_force * STREAM_FORCE_FACTOR; // kN

if (abs _target_speed > abs _cur_speed) then {
	_engine_force = _engine_force - _totalforces; // counteract drag
};

private _max_force = 80000 / (5 max abs _cur_speed); // kN

private _engine_percent = abs _engine_force / _max_force;
if (abs _engine_force > _max_force) then {
	_engine_force = _max_force * (_engine_force / abs _engine_force);
	_engine_percent = 1;
};

_debug pushBack ["engine_force", _engine_force];
_debug pushBack ["engine_percent", _engine_percent];
_totalforces = _totalforces + _engine_force;

// rudder answer:
// min speed
// random value: 5knots (2.6m/s)
// effectiveness
// quadratic with speed
// random values: at 15knots, 30° rudder, 500m turn radius
// TODO: those values are bs.
// TODO: wtf did I calculate here
// 15knots(~8m/s),500m radius(half circ. 1570m) -> 180° <=> 196s (eff= 26.4) -> X * 26.4 = 1.09° / s -> X = 0.0412
// TODO: should it become weaker at higher speeds or smth?
private _rudder_deg_per_sec = 0;
if (abs _cur_speed > RUDDER_MIN_SPEED) then
{
	// theoretical maximum: 13.4^2 * 0.0412 = 7.14
	_rudder_deg_per_sec = (_cur_rudder / MAX_RUDDER) * (abs _cur_speed - RUDDER_MIN_SPEED) * (abs _cur_speed - RUDDER_MIN_SPEED) * RUDDER_FACTOR;
	if (_cur_speed < 0) then { _rudder_deg_per_sec = -_rudder_deg_per_sec };
};
_debug pushBack ["rudder °/s", _rudder_deg_per_sec];

// turning motion
// center: 2/5 boat length, from bow
// must overcome rotational inertia <- effect of that should be rather low

// center for now. TODO
_yaw = _yaw - _rudder_deg_per_sec * _dt;

// rolling
// inertia, damping, max 4 degree. based on turn angle speed (TODO: meh. should be based on physics. not sure how)
// for now, just based on turning per second. TODO
//
_bank = -_rudder_deg_per_sec * 4 / 7.14;

_debug pushBack ["totalforce", _totalforces];
_debug pushBack ["acceleration", _totalforces / WEIGHT];

private _speed = _cur_speed + _dt * _totalforces / WEIGHT;

_debug pushBack ["last_speed", _cur_speed];

_debug pushBack ["speed", _speed];
_velocity = [_speed * sin _yaw, _speed * cos _yaw, 0];
_pos = _pos vectorAdd (_velocity vectorMultiply _dt);

_ship setVariable["cur_engine", _engine];
_ship setVariable["cur_rudder", _rudder];

_ship setVariable ["velocity", _velocity];


hintSilent ((_debug apply {format ["%1: %2", _x select 0, _x select 1]}) joinString "\n");

if (isNil "debug_frames") then {debug_frames = []};
if (abs _cur_speed < 100000) then {debug_frames pushBack _debug};

// just one velocity for the whole thing for now
[_pos, _velocity, [_yaw+180, _pitch, _bank]]
