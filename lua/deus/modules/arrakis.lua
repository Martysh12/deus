-- Arrakis Module for Deus
-- (c) 2021 Zeitgeist Studios
-- Your Hosts: ["Runic"]

function DeusArrakisWinRound(sCaller, Team)
	local _Team = Deus.ParseTargetData(tonumber(Team))
	if Team != "1" && Team != "2" then return end
	WinRound(tonumber(Team))
	Deusprint(sCaller, "ended round in favor of Team ", _Team)
end

Deus.AddCommand("arrakis", "win", function(ply, cmd, args)
	if !ply:IsDeus() then return end
	DeusArrakisWinRound(ply, args[1])
end)
