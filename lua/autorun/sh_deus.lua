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

-- METATABLES
DeusMetaPly = FindMetaTable("Player")

-- Set up Table
Deus = {...}
Deus.Commands = {}
Deus.Admins = {}
Deus.Modlist = file.Find("deus/modules/*", "LUA")

-- Load and Refresh Admin Adam
function Deus.RefreshAdmins()
	local JSONData = file.Read("deus/adam/admins.json")
	Deus.Admins = util.JSONToTable(JSONData)
	print("\n\n[DEUS] Loading Admins\n")
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
		print("-----[" .. Cat .. "]-----")
		for xk,xv in pairs(Deus.Commands[Cat]) do
			print("[" .. xk .. "]")
			concommand.Add("deus." .. k .. "." .. xk, xv)
		end
	end
end

-- Core Function to retrieve players
function Deus.ParseTargetData(sTarget, bMulti)
	local RET_PLYS = {}
	for k,v in pairs(player.GetAll()) do
		if string.find(string.lower(v:Name()), string.lower(sTarget), 0, true) != nil or string.find(string.lower(v:SteamID()), string.lower(sTarget), 0, true) then
			table.insert(RET_PLYS, v)
		end
	end

	if bMulti then
		return RET_PLYS
	end

	if #RET_PLYS == 1 then
		return RET_PLYS[1]
	else
		return false
	end
end

Deus.RefreshAdmins()
Deus.ConstructModules()
Deus.Populate()

end