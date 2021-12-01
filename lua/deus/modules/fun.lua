-- DEUS FUN MODULE
-- (c) 2021 Zeitgeist Studios
-- Your Hosts: ["Runic"]

-- deus.fun.ignite | Purpose: Destruction
function DeusIgnite(sCaller, Target, iSeconds)
	local Parsed = Deus.ParseTargetData(Target)
	Parsed:Ignite(tonumber(iSeconds))
	Deusprint(sCaller, "ignited(" .. iSeconds .. ")", Parsed)
end

Deus.AddCommand("fun", "ignite", function(ply, cmd, args)
	if !ply:IsDeus() then return end
	DeusIgnite(ply, args[1], args[2])
end)
