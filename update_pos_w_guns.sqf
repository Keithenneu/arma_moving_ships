params ["_carrierBase", "_velocity", "_rotation"];
_rotation params ["_yaw", "_pitch", "_bank"];

_carrierBase setVelocity _velocity;
private _carrierPartsArray = _carrierBase getVariable ["bis_carrierParts", []];

_carrierBase setDir _yaw;
[_carrierBase, _pitch, _bank] call BIS_fnc_setPitchBank;

{
    private _dummy = _x select 0;
    _dummy setDir _yaw;
    [_dummy, _pitch, _bank] call BIS_fnc_setPitchBank;
    _carrierPartPos = _carrierBase modelToWorldWorld (_carrierBase selectionPosition (_x select 1));
    _dummy setPosWorld _carrierPartPos;
    _dummy setVelocity _velocity;

} foreach _carrierPartsArray;

private _guns = _carrierBase getVariable ["guns", []];

{
    _x params ["_", "_gun", "_position_rel", "_dir_rel"];
    _gun setDir _yaw + _dir_rel;
    [_gun, _pitch, _bank] call BIS_fnc_setPitchBank;
    _gun setPosWorld (_carrierBase modelToWorldWorld _position_rel);
    _gun setVelocity _velocity;

} foreach _guns;