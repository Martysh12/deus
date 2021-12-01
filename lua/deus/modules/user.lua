-- DEUS USER MODULE
-- (c) 2021 Zeitgeist Studios
-- Your Hosts: ["Runic"]

-- deus.user.slay | Purpose: Destruction
function DeusSlay(sCaller, Target)
	local Snds = {
		"ambient/energy/zap8.wav",
		"ambient/energy/zap7.wav",
		"ambient/energy/zap6.wav"
	}
	local Parsed = Deus.ParseTargetData(Target,false)
	local Pos = Parsed:GetPos()
	Parsed:Spawn()
	Parsed:SetPos(Pos)
	local d = DamageInfo()
	d:SetDamage(Parsed:Health())
	d:SetAttacker(Parsed)
	d:SetInflictor(Parsed)
	d:SetDamageType(DMG_DISSOLVE)
	Parsed:EmitSound(Snds[math.random(#Snds)], 75,  math.random(80,120), 1, CHAN_AUTO)
	Parsed:TakeDamageInfo(d)
	Deusprint(sCaller, "slayed", Parsed)
end

Deus.AddCommand("user", "slay", "Slay [Player]", function(ply, cmd, args)
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

Deus.AddCommand("user", "kick", "Kicks Ply [Reason]", function(ply, cmd, args)
	if !ply:IsDeus() then return end
	DeusKick(ply, args[1], args[2])
end)

-- deus.user.ban | Purpose: Ban hoes, hang with bros?
function DeusBan(sCaller, Target, sMinutes, sReason)
	if sReason == nil then sReason = "Undocumented Deus Ban" end
	local Parsed = Deus.ParseTargetData(Target,false,true)
	Deus.Orion.Ban(sCaller, Parsed, sMinutes, sReason)
	Parsed:Kick(sReason)
	Deusprint(sCaller, [[ban (]] .. tonumber(sMinutes) .. [[ minutes) (]] .. sReason .. [[)]], Parsed)
end

Deus.AddCommand("user", "ban", "Bans [Ply/SteamID, Minutes, Reason]", function(ply, cmd, args)
	if !ply:IsDeus() then return end
	DeusBan(ply, args[1], args[2], args[3])
end)

-- deus.user.unban | Purpose: Ban hoes, hang with bros?
function DeusUnBan(sCaller, Target)
	local Parsed = Deus.ParseTargetData(Target,false,true)
	Deus.Orion.RMBan(sCaller, Parsed)
	Deusprint(sCaller, [[unban]], Parsed)
end

Deus.AddCommand("user", "unban", "Unbans [Ply/SteamID]", function(ply, cmd, args)
	if !ply:IsDeus() then return end
	DeusUnBan(ply, args[1])
end)
