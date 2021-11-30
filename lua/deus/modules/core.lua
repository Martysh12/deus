-- CORE DEUS MODULE
-- (c) 2021 Zeitgeist Studios
-- Your Hosts: ["Runic"]

-- Deus.core.refresh | Purpose: Loads and refreshes admins into a Table.
Deus.AddCommand("core", "refresh", function(ply, cmd, args)
	Deus.RefreshAdmins()
end)

-- deus.core.add | Purpose: Adds an Admin to admins
function DeusAddAdmin(sCaller, Target)
	-- Parse Target
	local Parsed = Deus.ParseTargetData(Target)

	-- If the Admin already exists...
	if table.HasValue(Deus.Admins, Parsed:SteamID()) then return end

	-- Else, add to Admins
	Deus.Admins[Parsed:SteamID()] = Parsed:Nick()
	file.Write("deus/adam/admins.json", util.TableToJSON(Deus.Admins))
	print("[DEUS] " .. sCaller:Name() .. " (" .. sCaller:SteamID() .. ") " .. "Added Admin: " .. Parsed:Nick())
	Deus.RefreshAdmins()
end

Deus.AddCommand("core", "add", function(ply, cmd, args)
	DeusAddAdmin(ply, args[1])
end)

-- deus.core.status | Purpose: Get Status of Player
function DeusStatus(sCaller, Target)
	-- Parse Target
	local Parsed = Deus.ParseTargetData(Target)
	print([[[DEUS] Deus status of Player < ]] .. Parsed:Nick() .. [[ > is < ]] .. tostring(Parsed:IsDeus()) .. [[ >]])
end

Deus.AddCommand("core", "status", function(ply, cmd, args)
	DeusStatus(ply, args[1])
end)