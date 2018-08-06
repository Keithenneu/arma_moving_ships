params ["_ship", "_args"];

// TODO: args?
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


// rudder drag
// linear with sin rudder(degree)


// engine:
// assume propulsion system emits water stream sufficient for holding desired speed
// acceleration force is based on the difference of that stream to ship speed
// but cant exceed engine power

// rudder:
// some old af battleship had -30° to 30°. should be good enough, at it's more for reference here

// rudder speed:
// random value: 10sec -30° to 30°

// rudder answer:
// min speed
// random value: 5knots


// turning motion
// center: 2/5 boat length, from bow
// must overcome rotational inertia


// effectiveness
// quadratic with speed
// random values: at 15knots, 30° rudder, 500m turn radius

// rolling
// inertia, damping, max 4 degree. based on turn angle speed (TODO: meh. should be based on physics. not sure how)

// for now: speed = target speed
// rudder effect = rudder setting. turns around base object center
// maxspeed: 31knots = 16m/s

_velocity = [_engine * 16 * _dt * sin _yaw, _engine * 16 * _dt * cos _yaw, 0];
_pos = _pos vectorAdd _velocity;
_yaw = _yaw - _rudder * 0.1 * _dt * _engine;


_ship setVariable ["velocity", _velocity];

// just one velocity for the whole thing for now
[_pos, _velocity, [_yaw+180, _pitch, _bank]]
