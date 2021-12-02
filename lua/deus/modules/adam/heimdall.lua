-- DEUS MODULE: "HEIMDALL" THREAT ASSESSMENT
-- (c) 2021 Zeitgeist Studios
-- Your Hosts: ["Runic"]

if ADAM then
	-- NetStr
	util.AddNetworkString("ToADAM_Heimdall")

	-- Init Main System and its Tables.
	Deus.Heimdall = {...}
	Deus.Heimdall.Profiles = {}
	Deus.Heimdall.Radar = {}

	-- Local Variant
	local _Deus = {...}

	_Deus.Heimdall = {...}
	_Deus.Heimdall.Key = file.Read("deus/adam/heimdall/api_key.txt")

	-- Factors which add to Threat Level
	Deus.Heimdall.Factors = {
		["shady_activity"] 		= 10,          	-- Shady website activity
		["vac_ban"]        		= 5,           	-- Is VAC banned
		["family_sharing"] 		= 20,          	-- Is family shared
		["community_ban"] 		= 10           	-- Has community ban
	}

	-- Deus.Heimdall.LoadRadar() | Initializes Radar list
	function Deus.Heimdall.LoadRadar()

		-- If Radar Adam is absent, create it.
		if not file.Exists("deus/adam/heimdall/radar.txt","DATA") then
			file.Write("deus/adam/heimdall/radar.txt","")
		end

		-- Feed the adam into a table.
		local RadarDat = file.Read("deus/adam/heimdall/radar.txt")
		Deus.Heimdall.Radar = string.Explode(RadarDat "\n")

		-- DEBUG: Print the Table.
		print("[DEUS] Heimdall Radarfile loaded:")
		PrintTable(Deus.Heimdall.Radar)

	end

	-- Deus.Heimdall.LoadRadar() | Initializes
	function Deus.Heimdall.LoadProfiles()

		-- If Heimdall Adam is absent, create it.
		if not file.Exists("deus/adam/heimdall/profiles.json","DATA") then
			file.Write("deus/adam/heimdall/profiles.json", util.TableToJSON(Deus.Heimdall.Profiles))
		end

		-- Feed the adam into a table.
		local JSONData = file.Read("deus/adam/heimdall/profiles.json")
		Deus.Heimdall.Profiles = util.JSONToTable(JSONData)

		-- DEBUG: Print the Table.
		print("[DEUS] Heimdall profiles loaded:")
		PrintTable(Deus.Heimdall.Profiles)

	end

	-- Deus.Heimdall.Init | Purpose: Reload and Initialize Heimdall
	function Deus.Heimdall.Init()

		-- Init Tables
		Deus.Heimdall.LoadProfiles()
		Deus.Heimdall.LoadRadar()

	end

	-- Heimdall Netreceive
	net.Receive("ToADAM_Heimdall", function(len,ply)
		Deus.Heimdall.Check(ply:SteamID())
	end)

	-- Deus.Heimdall.Check | Player joins and profile gets initialized
	function Deus.Heimdall.Check(steamid)

		-- Init Deus Profile
		Deus.Heimdall.Profiles[steamid] 					= {}
		Deus.Heimdall.Profiles[steamid]["info"] 			= {}
		Deus.Heimdall.Profiles[steamid]["threats"] 			= {}
		Deus.Heimdall.Profiles[steamid]["threatlevel"] 		= 0

		-- Init Profile Info
		Deus.Heimdall.Profiles[steamid]["info"]["steamid"] 	= steamid
		Deus.Heimdall.Profiles[steamid]["info"]["name"]		= player.GetBySteamID(steamid):Nick()

		-- Check threats
		http.Fetch("http://api.steampowered.com/IPlayerService/IsPlayingSharedGame/v0001/?key=" .. _Deus.Heimdall.Key .. "&steamid=" .. util.SteamIDTo64(steamid) .. "&appid_playing=4000&format=json", function(body,len,headers,code)
			local _body = util.JSONToTable(body)
			if _body["players"][1]["VACBanned"] == true then
				Deus.Heimdall.Profiles[steamid]["threats"]["VAC_Ban"] = 1
			else
				Deus.Heimdall.Profiles[steamid]["threats"]["family_shared"] = 0
			end
		end)

		-- Bans
		http.Fetch("http://api.steampowered.com/ISteamUser/GetPlayerBans/v1/?key=" .. _Deus.Heimdall.Key .. "&steamid=" .. util.SteamIDTo64(steamid), function(body,len,headers,code)
			local _body = util.JSONToTable(body)
			if _body["players"][1]["CommunityBanned"] == true then
				Deus.Heimdall.Profiles[steamid]["threats"]["Community_Ban"] = 1
			else
				Deus.Heimdall.Profiles[steamid]["threats"]["Community_Ban"] = 0
			end
		end)

		-- Write it to the Profile Adam.
		file.Write("deus/adam/heimdall/profiles.json", util.TableToJSON(Deus.Heimdall.Profiles))

	end

end