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

if SERVER then
	-- Net MSGs
	util.AddNetworkString("DeusPrint")

	-- METATABLES
	DeusMetaPly = FindMetaTable("Player")

	-- Set up Table
	Deus = {...}
	Deus.Console = {...}
	Deus.Commands = {}
	Deus.Admins = {}
	Deus.Modlist = file.Find("deus/modules/*", "LUA")

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
		net.Start("DeusPrint")
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

	-- Load Module List
	function Deus.ConstructModules()
		print("\n\n[DEUS] Adding Modules...\n")
		for _,v in pairs(Deus.Modlist) do
			local ModuleName = v
			print("- [" .. ModuleName .. "]")
			include("deus/modules/" .. ModuleName)
		end
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

	-- Initialize Deus
	function Deus.Init()
		include("deus/core/ban.lua")
		Deus.RefreshAdmins()
		Deus.ConstructModules()
		Deus.Populate()
		Deus.Orion.Refresh()
	end

	-- Case o' Point
	Deus.Init()

end

if CLIENT then

	-- DeusPrint | Logs into Chat
	net.Receive("DeusPrint",function()
		local Activator = net.ReadEntity()
		local Action = net.ReadString()
		local Target = net.ReadString()

		local _Activator
		local _Target

		if Activator:GetClass() != "worldspawn" then
			_Activator = Activator:Nick()
		else
			_Activator = "CONSOLE"
		end

		if !player.GetBySteamID(Target) then
			_Target = Target
		else
			_Target = player.GetBySteamID(Target):Nick()
		end

		DEUSCOLOR = Color(155,255,255)
		DEUS_ACTIONCOLOR = Color(255,255,255)
		DEUS_PLYCOLOR = Color(0,255,0)

		chat.AddText(DEUSCOLOR,"[DEUS] ", DEUS_PLYCOLOR, _Activator .. " ", DEUS_ACTIONCOLOR, Action .. " ", DEUS_PLYCOLOR, _Target .. " ")
	end)

end