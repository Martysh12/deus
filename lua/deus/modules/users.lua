-- DEUS USER MODULE
-- (c) 2021 Zeitgeist Studios
-- Your Hosts: ["Runic"]

-- deus.user.slay | Purpose: Destruction
function DeusSlay(sCaller, Target)
	local Parsed = Deus.ParseTargetData(Target)
	Parsed:Kill()
	Deusprint(sCaller, "slayed", Parsed)
end

Deus.AddCommand("user", "slay", function(ply, cmd, args)
	if !ply:IsDeus() then return end
	DeusSlay(ply, args[1])
end)

-- deus.user.kick | Purpose: Kick ass, mow grass?
function DeusKick(sCaller, Target, sReason)
	local Parsed = Deus.ParseTargetData(Target)
	Parsed:Kick(sReason)
	Deusprint(sCaller, [[kicked ("]] ..  .. [[")]], Parsed)
end

Deus.AddCommand("user", "kick", function(ply, cmd, args)
	if !ply:IsDeus() then return end
	DeusSlay(ply, args[1], args[2])
end)

-- deus.user.ban | Purpose: Ban hoes, hang with bros?
function DeusKick(sCaller, Target, sMinutes)
	local Parsed = Deus.ParseTargetData(Target)
	Parsed:Ban(tonumber(sMinutes),true)
	Deusprint(sCaller, [[banned (]] .. tonumber(sMinutes) .. [[ minutes)]], Parsed)
end

Deus.AddCommand("user", "ban", function(ply, cmd, args)
	if !ply:IsDeus() then return end
	DeusSlay(ply, args[1], args[2])
end)
