#include <a_samp>

#define COLOR_RED 0xCC0000AA
#define COLOR_YELLOW 0xFFFF00AA
#define COLOR_GREEN 0x33FF00AA
#define COLOR_CYAN 0x33FFFFAA
#define COLOR_BLUE 0x0000FFAA
#define COLOR_ORANGE 0xFFCC00AA
#define COLOR_PINK 0xFF66FFAA
#define COLOR_WHITE 0xFFFFFFAA
#define COLOR_BLACK 0x000000AA
#define COLOR_GREY 0xCCCCCCAA

new engineOn[MAX_VEHICLES];
new vehicleEntered[MAX_PLAYERS][MAX_VEHICLES];
new isinvehicle[MAX_PLAYERS];


forward Startup(playerid, vehicleid);

#define FILTERSCRIPT

#if defined FILTERSCRIPT

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print("      Engine On/Off FS by LarzI");
	print("--------------------------------------\n");
	return true;
}

public OnFilterScriptExit()
{
	return true;
}

#else

main()
{
	print("\n----------------------------------");
	print(" Blank Gamemode by your name here");
	print("----------------------------------\n");
}

#endif

public OnGameModeInit()
{
	return true;
}

public OnGameModeExit()
{
	return true;
}

public OnPlayerRequestClass(playerid, classid)
{
	return true;
}

public OnPlayerRequestSpawn(playerid)
{
	return true;
}

public OnPlayerConnect(playerid)
{
	return true;
}

public OnPlayerDisconnect(playerid, reason)
{
	return true;
}

public OnPlayerSpawn(playerid)
{
	return true;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	return true;
}

public OnPlayerEnterVehicle(playerid, vehicleid)
{
	isinvehicle[playerid] = true;
	return true;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	isinvehicle[playerid] = false;
	return true;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(isinvehicle[playerid] && newkeys == KEY_JUMP)
	{
	    engineOn[GetPlayerVehicleID(playerid)] = true;
	}
	return true;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	new pveh = GetVehicleModel(GetPlayerVehicleID(playerid));
	new vehicle = GetPlayerVehicleID(playerid);
	if(newstate == PLAYER_STATE_DRIVER && (pveh == 522 || pveh == 581 || pveh == 462 || pveh == 521 || pveh == 463 || pveh == 461 || pveh == 448 || pveh == 471 || pveh == 468 || pveh == 586) && (pveh != 509 && pveh != 481 && pveh != 510))
	{
		SetTimerEx("Startup", 1, false, "ii", playerid, vehicle);
	}
	else if(newstate == PLAYER_STATE_DRIVER)
	{
		SetTimerEx("Startup", 1, false, "ii", playerid, vehicle);
	}
	return true;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	new cmd[256], idx;
	cmd = strtok(cmdtext, idx);
	{
		if(!strcmp(cmd, "/startup", true))
		{
			if(engineOn[GetPlayerVehicleID(playerid)]) return SendClientMessage(playerid, COLOR_RED, "Engine already started!");
			if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_RED, "Do you think that you can start an engine which you don't have?");
			    {
						GetPlayerName(playerid, giveplayer, sizeof(giveplayer));
						GetPlayerName(playerid, sendername, sizeof(sendername));
						TogglePlayerControllable(playerid, 1);
						{
			if(GetPlayerState(playerid) == PLAYER_STATE_PASSENGER) return SendClientMessage(playerid, COLOR_RED, "Only the driver can do this!");

			engineOn[GetPlayerVehicleID(playerid)] = true;
			TogglePlayerControllable(playerid, 1);
			new playerveh = GetPlayerVehicleID(playerid);
			PutPlayerInVehicle(playerid, playerveh, 0);
          	GameTextForPlayer(playerid,"~r~Engine Started", 1000, 1);
			return true;
		}
		if(!strcmp(cmd, "/turnoff", true))
		{
			if(!engineOn[GetPlayerVehicleID(playerid)]) return SendClientMessage(playerid, COLOR_RED, "Engine not started!");
			if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_RED, "Do you think that you can start an engine which you don't have?");
			TogglePlayerControllable(playerid, 1);
			if(GetPlayerState(playerid) == PLAYER_STATE_PASSENGER) return SendClientMessage(playerid, COLOR_RED, "Only the driver can do this!");

			engineOn[GetPlayerVehicleID(playerid)] = false;
			RemovePlayerFromVehicle(playerid);
          	GameTextForPlayer(playerid,"~r~Engine Stoped", 1000, 1);
			return true;
		}
	}
	return false;
}

public Startup(playerid, vehicleid)
{
	if(GetPlayerState(playerid) == PLAYER_STATE_PASSENGER || engineOn[vehicleid])
	{
		//I do nothing!
	}
	else if(!engineOn[vehicleid] && !vehicleEntered[playerid][vehicleid] && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		SendClientMessage(playerid, COLOR_RED, "You have to do /startup to start your engine /turnoff to switch off!");
		TogglePlayerControllable(playerid, false);
		vehicleEntered[playerid][vehicleid] = true;
	}
	else if(!engineOn[vehicleid] && vehicleEntered[playerid][vehicleid] && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		SendClientMessage(playerid, COLOR_GREEN, "You have to do /startup to start your engine /turnoff to switch off!");
		TogglePlayerControllable(playerid, false);
	}
}

strtok(const string[], &index, const seperator[] = " ")
{
	new index2, result[30];
	index2 =  strfind(string, seperator, false, index);

	if(index2 == -1)
	{
		if(strlen(string) > index)
		{
			strmid(result, string, index, strlen(string), 30);
			index = strlen(string);
		}
		return result; // This string is empty, probably, if index came to an end
	}
	if(index2 > (index + 29))
	{
		index2 = index + 29;
		strmid(result, string, index, index2, 30);
		index = index2;
		return result;
	}
	strmid(result, string, index, index2, 30);
	index = index2 + 1;
	return result;
}

