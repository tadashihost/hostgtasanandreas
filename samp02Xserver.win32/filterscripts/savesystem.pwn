/*
    >>>---------------------------------------<<<
	*	=====================================   *
	*	= An Area system made by ElDiablo   =   *
	*	= Version 1.0 A, made at 07.02.2008 =   *
	*	= I dont care if you delete my name =   *
	*	= Dont claim it as yours as it isnt =   *
	*	=====================================   *
	>>>---------------------------------------<<<
	_____________________________________________

	* Quick Guide:

	    * How to install:
	    
	        * Extract the rar into your server folder
	        * Define the *.amx file into server.cfg
	        * Make two folders called 'Areas' and 'AreasEx'
	        * You're done, now you can use it.
	        * GOTO Line 185 and define your name instead of mine!
	        
		* How to use:
		
		    * Type in game /Area [Radius][Name] to save a simple area
		    * Type in game /AreaEx [RadiusX][RadiusY] to save a advanced area
		    
		    Area will do:
		    
				-----------
				|          |
				|          |
				|          |
				|          |
				-----------
				
			Area Ex will do:
			
			    ----------
			    |         |
			    |         |
			    |         |
			    |         |
			    |         |
			    |         |
			    |         |
			    |         |
			    ----------
			    
			Ofcourse, also able to do:
			
			    --------------------
			    |                   |
			    |                   |
			    |                   |
			    |                   |
				--------------------


		Usage of making AreaEx:
		
		
		=============================
		|                       	|
		|     He looks this way     |
		|             ^             |
		|             ^             |
		|        Player Face        |
		|             ^             |
		|             ^             |
		| From here, we see his ass |
		|                           |
		=============================
		
		/AreaEx [RadiusX][RadiusY]
		
		The Radius X, will make the distance infront of player face, and behind it,
		While the Radius Y, will make the distance besides player face.
		Example:
		
		/AreaEx 4 8 Test
		
		Will make something like:
		
		
		
		                  4
		=======================================
		|                       			  |
		|         He looks this way    		  |
		|                 ^            		  |
		|                 ^            		  |
	  8	|            Player Face       		  | 8
		|                 ^            		  |
		|                 ^            		  |
		| 	   From here, we see his ass 	  |
		|                           		  |
		=======================================
						  4
						  
		So, when ever the player is looking at,
		The first variable, will make his 'face' 'ass' grow,
		The second variable, will make his 'left' 'right' grow.
		
		Usage: The simple area, is better to make DM zones, or even protected houses,
		While the advanced area, is better for places like the pirate ship (LV)
		Which isnt equal, x = x < y = y, like ive showed in the last picture here.
		
		I hope this tutorial explains how to use it easly.
		
		* Return:
		
		    * When using the command, a file will be created with the name variable,
			  The file will contain this:
			  
			  ======================================================
			  
			  ==Details==

				====
 				Min x: Float
 				-
 				Max x: Float
  				-
 				Min y: Float
 				-
 				Max y: Float
 				====

			  ==IsPlayerInArea==

 				====
 				IsPlayerInArea(playerid, Min x, Max x, Min y, Max y)
 				====

			  ==Position==

 				====
 				Player Position X: Float
 				-
 				Player Position Y: Float
 				-
 				Player Position Z: Float
 				-
 				(X, Y, Z)
 				====

			  ==Command==
			  
				===
				if(strcmp(cmdtext, "/teleport", true) == 0)
				{
				    SetPlayerPos(playerid, X, Y, Z);
				    return true;
				}
				===
				
			  ==K_ZoneSystem==

			  	===
				K_CreateZone(AreaName[], Min x, Min y, Max x, Max y)
				===
				
			  ==GangZoneCreate==
			  
			    ===
			    GangZoneCreate(Min x, Min y, Max x, Max y)
			    ===
			    
			  ==PayPlayerInArea==
			  
			    ===
			    PayPlayerInArea(playerid, Min x, Max x, Min y, Max y, Money)
			    ===

			  ======================================================
			  
		* As you can see, this is the best area system could ever be made,
		  I hope you have easy usage, fun and save your time with this.
________________________________________________________________________________
*/

#include a_samp
#include dini

#define AllowedUsing "Cale" // Please type your name here, instead of mine.

#define COLOR_GREY 0xAFAFAFAA
#define COLOR_RED 0xAA3333AA
#define COLOR_SPRINGGREEN 0x00FF7FAA

#define FILTERSCRIPT

#if defined FILTERSCRIPT

new Object[4];

forward SetArea(playerid, Float:Radius, Name[]);
forward SetAreaEx(playerid, Float:FirstRadius, Float:SecondRadius, Name[]);
forward AutoRemove();

public SetArea(playerid, Float:Radius, Name[])
{
    new String[256];
	format(String, 256, "Areas/%s.Data", Name);

	new
		Float:pX[2], Float:pY[2], Float:pZ;
	
	GetPlayerPos(playerid, pX[0], pY[0], pZ);
	
	pX[1] = pX[0];
	pY[1] = pY[0];
	
	new UsageData[256];
	
	dini_Create(String);

	format(UsageData, 256, "\n\n ==== \n Min x: %f \n - \n Max x: %f \n  - \n Min y: %f \n - \n Max y: %f \n ==== \n", pX[0] - Radius / 2, pX[1] + Radius / 2, pY[0] - Radius / 2, pY[1] + Radius / 2);
	dini_Set(String, "==Details=", UsageData);
	format(UsageData, 256, "\n\n ==== \n IsPlayerInArea(playerid, %f, %f, %f, %f) \n ==== \n", pX[0] - Radius / 2, pX[1] + Radius / 2, pY[0] - Radius / 2, pY[1] + Radius / 2);
	dini_Set(String, "==IsPlayerInArea=", UsageData);
	format(UsageData, 256, "\n\n ==== \n SetPlayerWorldBounds(playerid, %f, %f, %f, %f) \n ==== \n", pX[1] + Radius / 2, pX[0] - Radius / 2, pY[1] + Radius / 2, pY[0] - Radius / 2);
    dini_Set(String, "==WorldBounds=", UsageData);
	format(UsageData, 256, "\n\n ==== \n Player Position X: %f \n - \n Player Position Y: %f \n - \n Player Position Z: %f \n - \n (%f, %f, %f) \n ==== \n", pX[0], pY[0], pZ, pX[0], pY[0], pZ);
	dini_Set(String, "==Position=", UsageData);
	format(UsageData, 256, "\n\n ==== \n if(strcmp(cmdtext, \"/teleport\", true) == 0) \n\r { \n\r\t SetPlayerPos(playerid, %f, %f, %f); \n\r\t return true; \n\r } \n\r ====", pX[0], pY[0], pZ);
	dini_Set(String, "==Command=", UsageData);
	format(UsageData, 256, "\n\n ==== \n K_CreateZone(%s, %f, %f, %f, %f, 0x00ffffff) \n ==== \n", Name, pX[0] - Radius / 2, pY[0] - Radius / 2, pX[1] + Radius / 2, pY[1] + Radius / 2);
	dini_Set(String, "==K_ZoneSystem=", UsageData);
	format(UsageData, 256, "\n\n ==== \n GangZoneCreate(%f, %f, %f, %f) \n ==== \n", pX[0] - Radius / 2, pY[0] - Radius / 2, pX[1] + Radius / 2, pY[1] + Radius / 2);
	dini_Set(String, "==GangZoneCreate=", UsageData);
	format(UsageData, 256, "\n\n ==== \n PayPlayerInArea(playerid, %f, %f, %f, %f, Money) \n ==== \n", pX[0] - Radius / 2, pX[1] + Radius / 2, pY[0] - Radius / 2, pY[1] + Radius / 2);
	dini_Set(String, "==PayPlayerInArea=", UsageData);
	
	print(String);
	
	Object[0] = CreateObject(1318, pX[0] - Radius, pY[0], pZ, 0, 0, 0);
	Object[1] = CreateObject(1318, pX[1] + Radius, pY[1], pZ, 0, 0, 0);
	Object[2] = CreateObject(1318, pX[0], pY[0] - Radius, pZ, 0, 0, 0);
	Object[3] = CreateObject(1318, pX[1], pY[1] + Radius, pZ, 0, 0, 0);
	
	SetTimer("AutoRemove", 10000, false);
	
	return true;
}

public SetAreaEx(playerid, Float:FirstRadius, Float:SecondRadius, Name[])
{
    new String[256];
	format(String, 256, "AreasEx/%s.Data", Name);

	new
		Float:pX[2], Float:pY[2], Float:pZ;

	GetPlayerPos(playerid, pX[0], pY[0], pZ);

	pX[1] = pX[0];
	pY[1] = pY[0];

	new UsageData[256];
	
	dini_Create(String);

	format(UsageData, 256, "\n\n ==== \n Min x: %f \n - \n Max x: %f \n  - \n Min y: %f \n - \n Max y: %f \n ==== \n", pX[0] - FirstRadius / 2, pX[1] + FirstRadius / 2, pY[0] - SecondRadius / 2, pY[1] + SecondRadius / 2);
    dini_Set(String, "==Details=", UsageData);
	format(UsageData, 256, "\n\n ==== \n IsPlayerInArea(playerid, %f, %f, %f, %f) \n ==== \n", pX[0] - FirstRadius / 2, pX[1] + FirstRadius / 2, pY[0] - SecondRadius / 2, pY[1] + SecondRadius / 2);
	dini_Set(String, "==IsPlayerInArea=", UsageData);
	format(UsageData, 256, "\n\n ==== \n SetPlayerWorldBounds(playerid, %f, %f, %f, %f) \n ==== \n", pX[1] + FirstRadius / 2, pX[0] - FirstRadius / 2, pY[1] + SecondRadius / 2, pY[0] - SecondRadius / 2);
    dini_Set(String, "==WorldBounds=", UsageData);
	format(UsageData, 256, "\n\n ==== \n Player Position X: %f \n - \n Player Position Y: %f \n - \n Player Position Z: %f \n - \n (%f, %f, %f) \n ==== \n", pX[0], pY[0], pZ, pX[0], pY[0], pZ);
    dini_Set(String, "==Position=", UsageData);
	format(UsageData, 256, "\n\n ==== \n if(strcmp(cmdtext, \"/teleport\", true) == 0) \n\r { \n\r\t SetPlayerPos(playerid, %f, %f, %f); \n\r\t return true; \n\r } \n\r ====", pX[0], pY[0], pZ);
	dini_Set(String, "==Command=", UsageData);
	format(UsageData, 256, "\n\n ==== \n K_CreateZone(%s, %f, %f, %f, %f, 0x00ffffff) \n ==== \n", Name, pX[0] - FirstRadius / 2, pY[0] - SecondRadius / 2, pX[1] + FirstRadius / 2, pY[1] + SecondRadius / 2);
	dini_Set(String, "==K_ZoneSystem=", UsageData);
	format(UsageData, 256, "\n\n ==== \n GangZoneCreate(%f, %f, %f, %f) \n ==== \n", pX[0] - FirstRadius / 2, pY[0] - SecondRadius / 2, pX[1] + FirstRadius / 2, pY[1] + SecondRadius / 2);
	dini_Set(String, "==GangZoneCreate=", UsageData);
	format(UsageData, 256, "\n\n ==== \n PayPlayerInArea(playerid, %f, %f, %f, %f, Money) \n ==== \n", pX[0] - FirstRadius / 2, pX[1] + FirstRadius / 2, pY[0] - SecondRadius / 2, pY[1] + SecondRadius / 2);
	dini_Set(String, "==PayPlayerInArea=", UsageData);

	Object[0] = CreateObject(1318, pX[0] - FirstRadius, pY[0], pZ, 0, 0, 0);
	Object[1] = CreateObject(1318, pX[1] + FirstRadius, pY[1], pZ, 0, 0, 0);
	Object[2] = CreateObject(1318, pX[0], pY[0] - SecondRadius, pZ, 0, 0, 0);
	Object[3] = CreateObject(1318, pX[1], pY[1] + SecondRadius, pZ, 0, 0, 0);
	
	SetTimer("AutoRemove", 10000, false);

	return true;
}

public OnFilterScriptInit()
{
	Object[0] = -1;
	return true;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	new
		Command[256], Global[256], AreaName[256], Variable, VariableEx, Index;
		
	Command = strtok(cmdtext, Index);
	
	if(strcmp(Command, "/area", true) == 0)
	{
	    if(strcmp(pName(playerid), AllowedUsing, true) == 1)
	    {
			if(Object[0] == -1)
			{
			    new String[256];
			    
	    		Global = strtok(cmdtext, Index);
	    		if(!strlen(Global))
	        		return SendClientMessage(playerid, COLOR_GREY, "* Usage: /Area [Radius][Name]");
	        	
				AreaName = strtok(cmdtext, Index);
	    		if(!strlen(AreaName))
	        		return SendClientMessage(playerid, COLOR_GREY, "* Usage: /Area [Radius][Name]");
				
				Variable = strval(Global);
		
				if(Variable < 4)
		    		return SendClientMessage(playerid, COLOR_GREY, "* Caution: Radius can not be less than 4");

				format(String, 256, "Areas/%s.Data", AreaName);
				
				if(dini_Exists(String))
				    return SendClientMessage(playerid, COLOR_GREY, "* Caution: This area file already exists");

				SetArea(playerid, Variable, AreaName);
				SendClientMessage(playerid, COLOR_SPRINGGREEN, "* Notice: Position has been saved, the area is setted in the file");
		
				return true;
			}
			else
			    return SendClientMessage(playerid, COLOR_RED, "* Error: Please wait 10 seconds before using again");
		}
		else
		    return SendClientMessage(playerid, COLOR_RED, "* Error: You are not allowed using this!");
	}
	if(strcmp(Command, "/areaex", true) == 0)
	{
	    if(strcmp(pName(playerid), AllowedUsing, true) == 0)
	    {
			if(Object[0] == -1)
			{
			    new String[256];

	    		Global = strtok(cmdtext, Index);
	    		if(!strlen(Global))
	        		return SendClientMessage(playerid, COLOR_GREY, "* Usage: /Area [Radius][Radius][Name]");

                Variable = strval(Global);

	    		Global = strtok(cmdtext, Index);
	    		if(!strlen(Global))
	        		return SendClientMessage(playerid, COLOR_GREY, "* Usage: /Area [Radius][Radius][Name]");

				AreaName = strtok(cmdtext, Index);
	    		if(!strlen(AreaName))
	        		return SendClientMessage(playerid, COLOR_GREY, "* Usage: /Area [Radius][Radius][Name]");

				VariableEx = strval(Global);

				if(Variable < 4)
		    		return SendClientMessage(playerid, COLOR_GREY, "* Caution: Radius can not be less than 4");

				if(VariableEx < 4)
		    		return SendClientMessage(playerid, COLOR_GREY, "* Caution: Radius can not be less than 4");

				format(String, 256, "AreasEx/%s.Data", AreaName);

				if(dini_Exists(String))
				    return SendClientMessage(playerid, COLOR_GREY, "* Caution: This area file already exists");

				SetAreaEx(playerid, Variable, VariableEx, AreaName);
				SendClientMessage(playerid, COLOR_SPRINGGREEN, "* Notice: Position has been saved, the area is setted in the file");

				return true;
			}
			else
			    return SendClientMessage(playerid, COLOR_RED, "* Error: Please wait 10 seconds before using again");
		}
		else
		    return SendClientMessage(playerid, COLOR_RED, "* Error: You are not allowed using this!");
	}
	return false;
}

public AutoRemove()
{
	DestroyObject(Object[0]);
	DestroyObject(Object[1]);
	DestroyObject(Object[2]);
	DestroyObject(Object[3]);
	
	Object[0] = -1;

	return true;
}

stock pName(playerid)
{
	new PlayerName[24];
	GetPlayerName(playerid, PlayerName, sizeof(PlayerName));
	return PlayerName;
}

stock IsPlayerInArea(playerid, Float:x_min, Float:x_max, Float:y_min, Float:y_max)
{
	new
		Float:pX, Float:pY, Float:pZ;

	GetPlayerPos(playerid, pX, pY, pZ);

	if(pX >= x_min && pX <= x_max && pY >= y_min && pY <= y_max)
	    return true;

	else
	    return false;

	return true;
}

stock PayPlayerInArea(playerid, Float:MinX, Float:MaxX, Float:MinY, Float:MaxY, Money)
{
	if(IsPlayerConnected(playerid))
	{
		new
			Float:pX, Float:pY, Float:pZ;

		GetPlayerPos(playerid, pX, pY, pZ);

		if(pX >= MinX && pX <= MaxX && pY >= MinY && pY <= MaxY)
		{
			GivePlayerMoney(playerid, Money);
			return true;
		}
	}
	return false;
}

#endif
