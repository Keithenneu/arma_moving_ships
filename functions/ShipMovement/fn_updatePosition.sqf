params ["_ship", "_state"];
_state params ["_position", "_velocity", "_rotation"];
_rotation params ["_yaw", "_pitch", "_bank"];


diag_log str ["ships_updateposistion", _state];

_ship setPosASL _position;
_ship setVelocity _velocity;
private _carrierPartsArray = _ship getVariable ["bis_carrierParts", []];

_ship setDir _yaw;
[_ship, _pitch, _bank] call BIS_fnc_setPitchBank;

{
    private _dummy = _x select 0;
    _dummy setDir _yaw;
    [_dummy, _pitch, _bank] call BIS_fnc_setPitchBank;
    _carrierPartPos = _ship modelToWorldWorld (_ship selectionPosition (_x select 1));
    _dummy setPosWorld _carrierPartPos;
    _dummy setVelocity _velocity;

} foreach _carrierPartsArray;

private _guns = _ship getVariable ["guns", []];

{
    _x params ["_", "_gun", "_position_rel", "_dir_rel"];
    _gun setDir _yaw + _dir_rel;
    [_gun, _pitch, _bank] call BIS_fnc_setPitchBank;
    _gun setPosWorld (_ship modelToWorldWorld _position_rel);
    _gun setVelocity _velocity;

} foreach _guns;
