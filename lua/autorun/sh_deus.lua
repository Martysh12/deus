/*------------------------------------------------------------------
--- --------------- DEUS ADMIN MOD BY RUNIC --------------------- --
--- -------------- USAGE: MANAGING ARRAKIS  --------------------- --
--- ----------------------------------------------------------------
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


	function Deus.Console:Nick()
		return "CONSOLE"
	end
	function Deus.Console:SteamID()
		return "CONSOLE"
	end

	function Deusprint(tPly, tAct, tTarget)
		local tLogData = {}
		tLogData.Activator = tPly
		if tLogData.Activator == nil then
			tLogData.Activator = Deus.Console
		end
		tLogData.Action = tAct
		tLogData.Target = tTarget
		local LogLine
		if tLogData.Target:Nick() != nil then
			LogLine = "[DEUS] " .. os.date("[%d/%m/%Y | %H:%M:%S] " , Timestamp) ..  (tLogData.Activator:Nick()) .. " " .. tLogData.Action .. " " .. tLogData.Target:Nick() .. "\n"
		else
			LogLine = "[DEUS] " .. os.date("[%d/%m/%Y | %H:%M:%S] " , Timestamp) ..  (tLogData.Activator:Nick()) .. " " .. tLogData.Action .. " " .. tLogData.Target .. "\n"
		end
		print(LogLine)
		file.Append("deus/adam/log.txt", LogLine)
		DeusLog(tLogData)
	end

	function DeusLog(tLogData)
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
		local JSONData = file.Read("deus/adam/admins.json")
		Deus.Admins = util.JSONToTable(JSONData)
		print("[DEUS] Loading Admins")
		PrintTable(Deus.Admins)
	end

	-- Status Property
	function DeusMetaPly:IsDeus()
		return Deus.Admins[self:SteamID()] != nil
	end

	-- CORE SHARED
	function Deus.AddCommand(sCategory, sName, funcCallback)
		if Deus.Commands[sCategory] == nil then
			Deus.Commands[sCategory] = {}
		end
		Deus.Commands[sCategory][sName] = funcCallback
	end

	-- Load Module List
	function Deus.ConstructModules()
		print("\n\n[DEUS] Adding Modules...\n")
		for _,v in pairs(Deus.Modlist) do
			local ModuleName = v
			print("-----[" .. ModuleName .. "]-----")
			include("deus/modules/" .. ModuleName)
		end
	end

	-- Populate commands ingame
	function Deus.Populate()
		print("\n\n[DEUS] Adding Commands...\n")
		for k,v in pairs(Deus.Commands) do
			local Cat = k
			print("\n-----[" .. Cat .. "]-----")
			for xk,xv in pairs(Deus.Commands[Cat]) do
				print("[" .. xk .. "]")
				concommand.Add("deus." .. k .. "." .. xk, xv)
			end
		end
	end

	-- Core Function to retrieve players
	function Deus.ParseTargetData(sTarget, bMulti)
		local RET_PLYS = {}
		local Fallback = {}

		function Fallback:SteamID()
			return sTarget;
		end
		function Fallback:Nick()
			return sTarget;
		end

		if isstring(sTarget) then
			for k,v in pairs(player.GetAll()) do
				if string.find(string.lower(v:Name()), string.lower(sTarget), 0, true) != nil or string.find(string.lower(v:SteamID()), string.lower(sTarget), 0, true) then
					table.insert(RET_PLYS, v)
				end
			end
		end

		if bMulti then
			return RET_PLYS
		end

		if #RET_PLYS == 1 then
			return RET_PLYS[1]
		else
			return Fallback;
		end
	end

	function Deus.Init()
		Deus.RefreshAdmins()
		Deus.ConstructModules()
		Deus.Populate()
	end

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