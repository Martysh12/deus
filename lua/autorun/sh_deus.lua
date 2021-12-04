/*------------------------------------------------------------------
--- -------------- DEUS ADMIN MOD BY RUNIC  --------------------- --
--- -------------- USAGE: MANAGING ARRAKIS  --------------------- --
--- ------------------------------------------------------------- --
---							INFO:								  --
---	------------------------------------------------------------- --
---		adam files are serverside configs						  --
---		eve files are clientside configs						  --
---		that way it is evident what is secured on the server	  --
---		and what is not.										  --
------------------------------------------------------------------*/
ADAM 	= 		SERVER
EVE 	= 		CLIENT


-- Set up Table
Deus = {...}

Deus.Modlist = {}
Deus.Modlist.EVE = file.Find("deus/modules/eve/*", "LUA")

-- Construct EVE Modules
function Deus.ConstructEVE()
	if ADAM then
		print("\n\n[DEUS] Adding [EVE] Modules...\n")
		for _,v in pairs(Deus.Modlist.EVE) do
			local ModuleName = v
			print("- [" .. ModuleName .. "]")
			AddCSLuaFile("deus/modules/eve/" .. ModuleName)
		end
	end
	if EVE then
		for _,v in pairs(Deus.Modlist.EVE) do
			local ModuleName = v
			include("deus/modules/eve/" .. ModuleName)
		end
	end
end

if ADAM then
	-- Net MSGs
	util.AddNetworkString("ToEVE_DeusPrint")

	-- METATABLES
	DeusMetaPly = FindMetaTable("Player")

	-- Set up basic structure
	Deus.Console = {...}
	Deus.DummyPly = {...}
	Deus.Commands = {}
	Deus.Admins = {}
	Deus.Modlist.ADAM = file.Find("deus/modules/adam/*", "LUA")


	-- Construct ADAM Modules
	function Deus.ConstructADAM()
		print("\n\n[DEUS] Adding [ADAM] Modules...\n")
		for _,v in pairs(Deus.Modlist.ADAM) do
			local ModuleName = v
			print("- [" .. ModuleName .. "]")
			include("deus/modules/adam/" .. ModuleName)
		end
	end

	-- Fallback Console Activator
	function Deus.Console:Nick()
		return "CONSOLE"
	end
	function Deus.Console:SteamID()
		return "CONSOLE"
	end
	function Deus.Console:IsDeus()
		return true
	end

	-- Fallback DummyPly
	function Deus.DummyPly:Nick()
		return ""
	end
	function Deus.DummyPly:SteamID()
		return ""
	end
	function Deus.DummyPly:IsDeus()
		return false
	end
	-- Logger Stage 1
	function Deusprint(tPly, tAct, tTarget)
		-- Build LogData Table
		local tLogData = {}

		-- Activator
		tLogData.Activator = tPly

		if tLogData.Activator == nil or tLogData.Activator == "" then
			tLogData.Activator = Deus.Console
		end

		-- Action and Target
		tLogData.Action = tAct
		tLogData.Target = tTarget

		-- Introduce Logline Var
		local LogLine

		-- If Target has a nick, its a player, if not, its something else, so we log a string!
		if tLogData.Target:Nick() != nil then
			LogLine = "[DEUS] " .. os.date("[%d/%m/%Y | %H:%M:%S] " , Timestamp) ..  (tLogData.Activator:Nick()) .. " " .. tLogData.Action .. " " .. tLogData.Target:Nick() .. "\n"
		else
			LogLine = "[DEUS] " .. os.date("[%d/%m/%Y | %H:%M:%S] " , Timestamp) ..  (tLogData.Activator:Nick()) .. " " .. tLogData.Action .. " " .. tLogData.Target .. "\n"
		end

		-- Log Server, File and Client
		print(LogLine)
		file.Append("deus/adam/log.txt", LogLine)
		DeusLog(tLogData)
	end

	-- Logger Stage 2
	function DeusLog(tLogData)
		-- Send NetMSG and Broadcast it
		net.Start("ToEVE_DeusPrint")
			net.WriteEntity(tLogData.Activator)
			net.WriteString(tLogData.Action)
			if tLogData.Target != nil && tLogData.Target:SteamID() != nil then
				net.WriteString(tLogData.Target:SteamID())
			elseif tLogData.Target != nil && !isentity(tLogData.Target) then
				net.WriteString(tostring(tLogData.Target))
			end
		net.Broadcast()
	end

	-- Load and Refresh Admin Adam
	function Deus.RefreshAdmins()
		if !file.Exists("deus/adam/admins.json","DATA") then
			file.Write("deus/adam/admins.json", util.TableToJSON(Deus.Admins))
		end
		local JSONData = file.Read("deus/adam/admins.json")
		Deus.Admins = util.JSONToTable(JSONData)
		print("\n\n[DEUS] Loading Admins\n")
		PrintTable(Deus.Admins)
	end

	-- Status Property
	function DeusMetaPly:IsDeus()
		return Deus.Admins[self:SteamID()] != nil
	end

	-- Command Register
	function Deus.AddCommand(sCategory, sName, sDesc, funcCallback)
		if Deus.Commands[sCategory] == nil then
			Deus.Commands[sCategory] = {}
		end
		Deus.Commands[sCategory][sName] = {}
		Deus.Commands[sCategory][sName]["1"] = sDesc
		Deus.Commands[sCategory][sName]["2"] = funcCallback
	end

	-- Populate commands ingame
	function Deus.Populate()
		print("\n\n[DEUS] Adding Commands...")
		for k,v in pairs(Deus.Commands) do
			local Cat = k
			print("\n-----[deus." .. Cat .. "]-----")
			for xk,xv in pairs(Deus.Commands[Cat]) do
				print("[" .. xk .. "]\t-\t" .. xv["1"] .. "")
				concommand.Add("deus." .. k .. "." .. xk, xv["2"])
			end
		end
	end

	-- Core Function to retrieve players
	function Deus.ParseTargetData(sTarget, bMulti, bSID)

		local RET_PLYS = {}

		-- Fallback if its not a player, so we fake it
		local Fallback = {}

		-- Case o' point.
		function Fallback:SteamID()
			return sTarget;
		end
		function Fallback:Nick()
			return sTarget;
		end

		-- Actual Player
		if isstring(sTarget) then
			for k,v in pairs(player.GetAll()) do
				if string.find(string.lower(v:Name()), string.lower(sTarget), 0, true) != nil or string.find(string.lower(v:SteamID()), string.lower(sTarget), 0, true) then
					table.insert(RET_PLYS, v)
				end
			end
		end

		-- Multiple Players
		if bMulti then
			return RET_PLYS
		end

		-- If its only one result, Return the first (and only one)
		if #RET_PLYS == 1 then
			return RET_PLYS[1]
		-- If No one is found, it is a STEAMID
		else
			if bSID then
				return Fallback;
			else
				return;
			end
		end
	end
end

-- Initialize Deus
function Deus.Init()
	-- Modules
	Deus.ConstructEVE()
	if ADAM then
		Deus.ConstructADAM()
		include("deus/core/ban.lua")
		Deus.RefreshAdmins()
		Deus.Populate()
		Deus.Orion.Refresh()
		hook.Add("CheckPassword", "DEUS.ORION.BANCHECKER", Deus.Orion.chkbn, HOOK_LOW)
	end
end
Deus.Init()