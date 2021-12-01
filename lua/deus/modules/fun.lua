-- DEUS FUN MODULE
-- (c) 2021 Zeitgeist Studios
-- Your Hosts: ["Runic"]

-- deus.fun.slay | Purpose: Destruction
function DeusIgnite(sCaller, Target, iSeconds)
	-- Parse Target
	local Parsed = Deus.ParseTargetData(Target)

	Parsed:Ignite()

	Deusprint(sCaller, "ignited(" .. iSeconds .. ")", Parsed)
end

Deus.AddCommand("fun", "ignite", function(ply, cmd, args)
	if !ply:IsDeus() then return end
	DeusIgnite(ply, args[1], args[2])
end)
