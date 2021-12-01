-- DEUS USER MODULE
-- (c) 2021 Zeitgeist Studios
-- Your Hosts: ["Runic"]

-- deus.user.slay | Purpose: Destruction
function DeusSlay(sCaller, Target)
	local Parsed = Deus.ParseTargetData(Target,false)
	local d = DamageInfo()
	d:SetDamage(Parsed:Health())
	d:SetAttacker(sCaller)
	d:SetInflictor(sCaller)
	d:SetDamageType(DMG_DISSOLVE)
	Parsed:GodDisable()
	Parsed:TakeDamageInfo(d)
	Deusprint(sCaller, "slayed", Parsed)
end

Deus.AddCommand("user", "slay", function(ply, cmd, args)
	if !ply:IsDeus() then return end
	DeusSlay(ply, args[1])
end)

-- deus.user.kick | Purpose: Kick ass, mow grass?
function DeusKick(sCaller, Target, sReason)
	if sReason == nil then sReason = "Undocumented Deus Kick" end
	local Parsed = Deus.ParseTargetData(Target,false)
	Parsed:Kick(sReason)
	Deusprint(sCaller, [[kick ("]] .. sReason .. [[")]], Parsed)
end

Deus.AddCommand("user", "kick", function(ply, cmd, args)
	if !ply:IsDeus() then return end
	DeusKick(ply, args[1], args[2])
end)

-- deus.user.ban | Purpose: Ban hoes, hang with bros?
function DeusBan(sCaller, Target, sMinutes, sReason)
	if sReason == nil then sReason = "Undocumented Deus Ban" end
	local Parsed = Deus.ParseTargetData(Target,false)
	Parsed:Ban(tonumber(sMinutes),false)
	Parsed:Kick(sReason)
	Deusprint(sCaller, [[ban (]] .. tonumber(sMinutes) .. [[ minutes) (]] .. sReason .. [[)]], Parsed)
end

Deus.AddCommand("user", "ban", function(ply, cmd, args)
	if !ply:IsDeus() then return end
	DeusBan(ply, args[1], args[2], args[3])
end)
