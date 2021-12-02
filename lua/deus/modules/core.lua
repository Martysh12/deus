-- CORE DEUS MODULE
-- (c) 2021 Zeitgeist Studios
-- Your Hosts: ["Runic"]

-- Deus.core.refresh | Purpose: Loads and refreshes everything
Deus.AddCommand("core", "refresh", "Refreshes Deus", function(ply, cmd, args)
	if !ply:IsValid() then ply = Deus.Console end
	if !ply:IsDeus() then return end
	Deusprint(ply, "re-initialized deus.", Deus.DummyPly)
	Deus.Init()
end)

-- deus.core.add | Purpose: Adds an Admin to admins
function DeusAddAdmin(sCaller, Target)
	-- Parse Target
	local Parsed = Deus.ParseTargetData(Target,false,true)

	-- If the Admin already exists...
	if table.HasValue(Deus.Admins, Parsed:SteamID()) then return end

	-- Else, add to Admins
	Deus.Admins[Parsed:SteamID()] = Parsed:Nick()
	file.Write("deus/adam/admins.json", util.TableToJSON(Deus.Admins))
	Deusprint(sCaller, "added admin", Parsed)
	Deus.RefreshAdmins()
end

Deus.AddCommand("core", "add", "Adds Deus [Player or SteamID]", function(ply, cmd, args)
	if !ply:IsValid() then ply = Deus.Console end
	if !ply:IsDeus() then return end
	DeusAddAdmin(ply, args[1])
end)

-- deus.core.rm | Purpose: Removes an Admin
function DeusRmAdmin(sCaller, Target)
	-- Parse Target
	local Parsed = Deus.ParseTargetData(Target,false,true)

	-- remove
	Deus.Admins[Parsed:SteamID()] = nil
	file.Write("deus/adam/admins.json", util.TableToJSON(Deus.Admins))
	Deusprint(sCaller, "removed admin", Parsed)
	Deus.RefreshAdmins()
end

Deus.AddCommand("core", "rm", "Removes Deus [Player or SteamID]", function(ply, cmd, args)
	if !ply:IsValid() then ply = Deus.Console end
	if !ply:IsDeus() then return end
	DeusRmAdmin(ply, args[1])
end)

-- deus.core.status | Purpose: Get Status of Player
function DeusStatus(sCaller, Target)
	-- Parse Target
	local Parsed = Deus.ParseTargetData(Target,false)
	print([[[DEUS] Deus status of Player < ]] .. Parsed:Nick() .. [[ > is < ]] .. tostring(Parsed:IsDeus()) .. [[ >]])
end

Deus.AddCommand("core", "status", "Shows IsDeus [Player]", function(ply, cmd, args)
	if !ply:IsValid() then ply = Deus.Console end
	if !ply:IsDeus() then return end
	DeusStatus(ply, args[1])
end)