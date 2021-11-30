-- DEUS FUN MODULE
-- (c) 2021 Zeitgeist Studios
-- Your Hosts: ["Runic"]

-- deus.fun.slay | Purpose: Destruction
function DeusSlay(sCaller, Target)
	-- Parse Target
	local Parsed = Deus.ParseTargetData(Target)

	Parsed:Kill()

	Deusprint(sCaller, "slayed", Parsed)
end

Deus.AddCommand("fun", "slay", function(ply, cmd, args)
	if !ply:IsDeus() then return end
	DeusSlay(ply, args[1])
end)
