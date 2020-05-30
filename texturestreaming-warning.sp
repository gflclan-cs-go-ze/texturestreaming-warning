#include <sourcemod>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo =
{
	name = "[CS:GO] Texture Streaming Warning",
	author = "Vauff",
	description = "Warns players who have texture streaming enabled to turn it off, to prevent visual bugs and client crashes",
	version = "1.0",
	url = ""
};

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	if (GetEngineVersion() != Engine_CSGO)
	{
		FormatEx(error, err_max, "This plugin only works on CS:GO");
		return APLRes_Failure;
	}

	return APLRes_Success;
}

public void OnMapStart()
{
	CreateTimer(30.0, WarningTimer, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
}

public Action WarningTimer(Handle timer)
{
	for (int client = 1; client <= MaxClients; client++)
	{
		if (!IsValidClient(client))
			continue;

		QueryClientConVar(client, "mat_texturestreaming", QueryFinished);
	}

	return Plugin_Continue;
}

public void QueryFinished(QueryCookie cookie, int client, ConVarQueryResult result, const char[] cvarName, const char[] cvarValue)
{
	if (!IsValidClient(client))
		return;

	if (StrEqual(cvarValue, "1"))
		PrintToChat(client, " \x02[GFL] \x07To fix visual bugs and client crashes on custom maps, you must disable \x06Texture Streaming \x07in your CS:GO video settings");
}

bool IsValidClient(int client, bool nobots = false)
{
	if (client <= 0 || client > MaxClients || !IsClientConnected(client) || (nobots && IsFakeClient(client)))
		return false;

	return IsClientInGame(client);
}