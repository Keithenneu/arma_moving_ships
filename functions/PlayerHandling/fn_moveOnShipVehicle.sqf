params ["_helo", "_obj"];
private _force = _this select 4;
if (_obj in ships_epe_parts) then {
	private _force = (_this select 4) / (getMass _helo / 200); // idle force is roughly weight / 200
	_force = (0 max _force) min 1;
	hintSilent str _force;
	private _v_pad = velocity _obj;
	private _v_helo = velocity _helo;
	private _v_res = _v_helo vectorMultiply (1 - _force) vectorAdd (_v_pad vectorMultiply _force);
	_helo setVelocity _v_res;
};
