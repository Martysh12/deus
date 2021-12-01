-- DEUS FUN MODULE
-- (c) 2021 Zeitgeist Studios
-- Your Hosts: ["Runic"]

-- deus.fun.ignite | Purpose: Destruction
function DeusIgnite(sCaller, Target, iSeconds)
	local Parsed = Deus.ParseTargetData(Target,false)
	Parsed:EmitSound("ambient/fire/gascan_ignite1.wav", 75, math.random(80,120), 1, CHAN_AUTO)
	Parsed:Ignite(tonumber(iSeconds))
	Deusprint(sCaller, "ignited(" .. iSeconds .. ")", Parsed)
end

Deus.AddCommand("fun", "ignite", function(ply, cmd, args)
	if !ply:IsDeus() then return end
	DeusIgnite(ply, args[1], args[2])
end)

-- deus.fun.explode | Purpose: Destruction
function DeusSplode(sCaller, Target)
	local Snds = {
		"ambient/explosions/explode_4.wav",
		"ambient/explosions/explode_5.wav",
	}
	local Parsed = Deus.ParseTargetData(Target,false)
	local Pos = Parsed:GetPos()
	Parsed:Spawn()
	Parsed:SetPos(Pos)
	Parsed:EmitSound(Snds[math.random(#Snds)], 75,  math.random(80,120), 1, CHAN_AUTO)
	local explode = ents.Create("env_explosion")
	explode:SetPos(Pos)
	explode:Spawn()
	explode:SetKeyValue("iMagnitude", "155")
	explode:Fire("Explode", 0, 0)
	Deusprint(sCaller, "exploded", Parsed)
end


Deus.AddCommand("fun", "explode", function(ply, cmd, args)
	if !ply:IsDeus() then return end
	DeusSplode(ply, args[1])
end)
