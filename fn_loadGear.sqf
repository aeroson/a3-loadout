/*

	EDIT BY: aeroson (github.com/aeroson/a3-loadout)
	
	DESCRIPTION:
	this is edited function of VAS
	http://forums.bistudio.com/showthread.php?149077-Virtual-Ammobox-System-(VAS)
	
	REQUIRES:
	in client's init:
	getLoadout = compile preprocessFileLineNumbers 'get_loadout.sqf';
	setLoadout = compile preprocessFileLineNumbers 'set_loadout.sqf';
	
	USAGE:
	replace 'VAS\functions\fn_loadGear.sqf'
	with this script		
      
*/

#include "macro.sqf"

private["_slot","_loadout","_primary","_launcher","_handgun","_magazines","_uniform","_vest","_backpack","_items","_primitems","_secitems","_handgunitems","_uitems","_vitems","_bitems","_handle"];
if(!isNil {VAS_loadout_ip}) exitWith {};
_slot = if(isNil {_this select 0}) then {lbCurSel VAS_load_list} else {_this select 0};
if(_slot == -1) exitWith {hint "You didn't select a slot to load!";};
if(vas_disableLoadSave) then
{
	_loadout = missionNamespace getVariable format["vas_gear_new_%1",_slot];
}
	else
{
	_loadout = profileNamespace getVariable format["vas_gear_new_%1",_slot];
};

if(isNil {_loadout}) exitWith {}; //Slot data doesn't exist

VAS_loadout_ip = true;

	
_primary = _loadout select 1;
_launcher = _loadout select 2;
_handgun = _loadout select 3;
_magazines = _loadout select 4;
_uniform = _loadout select 5;
_vest = _loadout select 6;
_backpack = _loadout select 7;
_items = _loadout select 8;
_primitems = _loadout select 9;
_secitems = _loadout select 10;
_handgunitems = _loadout select 11;
_uitems = _loadout select 12;
_vitems = _loadout select 13;
_bitems = _loadout select 14;

if(isNil{setLoadout}) then {
	
	//Strip the unit down
	RemoveAllWeapons player;
	{player removeMagazine _x;} foreach (magazines player);
	removeUniform player;
	removeVest player;
	removeBackpack player;
	removeGoggles player;
	removeHeadGear player;
	{
		player unassignItem _x;
		player removeItem _x;
	} foreach (assignedItems player);
	
	//Add the gear
	if(_uniform != "") then {_handle = [_uniform,true,false,false,false] spawn VAS_fnc_handleItem; waitUntil {scriptDone _handle};};
	if(_vest != "") then {_handle = [_vest,true,false,false,false] spawn VAS_fnc_handleItem; waitUntil {scriptDone _handle};};
	if(_backpack != "") then {_handle = [_backpack,true,false,false,false] spawn VAS_fnc_handleItem; waitUntil {scriptDone _handle};};
	{
		_handle = [_x,true,false,false,false] spawn VAS_fnc_handleItem;
		waitUntil {scriptDone _handle};
	} foreach _magazines;
	
	if(_primary != "") then {[_primary,true,false,false,false] spawn VAS_fnc_handleItem;};
	if(_launcher != "") then {[_launcher,true,false,false,false] spawn VAS_fnc_handleItem;};
	if(_handgun != "") then {[_handgun,true,false,false,false] spawn VAS_fnc_handleItem;};
	
	{_handle = [_x,true,false,false,false] spawn VAS_fnc_handleItem; waitUntil {scriptDone _handle};} foreach _items;
	{[_x,true,false,false,true] call VAS_fnc_handleItem;} foreach (_uitems);
	{[_x,true,false,false,true] call VAS_fnc_handleItem;} foreach (_vitems);
	{[_x,true,true,false,false] call VAS_fnc_handleItem;} foreach (_bitems);
	{[_x,true,false,true,false] call VAS_fnc_handleItem;} foreach (_primitems);
	{[_x,true,false,true,false] call VAS_fnc_handleItem;} foreach (_secitems);
	{[_x,true,false,true,false] call VAS_fnc_handleItem;} foreach (_handgunitems);  
	
	if(primaryWeapon player != "") then
	{
		player selectWeapon (primaryWeapon player);
	};

} else {

	[player,
		[
			_items, // assigned items
			
			_primary, // primary
			_primitems, // primary items
			
			_handgun, // handgun
			_handgunitems, // handugn items 
			
			_launcher, // secondary
			_secitems, // secondary items
			
			_uniform, // uniform
			_uitems, // uniform items
			
			_vest, // vest
			_vitems, // vest items
			
			_backpack, // backpack
			_bitems, // backpack items
			
			[_magazines,[],[]] // loaded magazines
		]
	] call setLoadout;

};

VAS_loadout_ip = nil;
