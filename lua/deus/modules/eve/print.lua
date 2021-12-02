if EVE then
    -- DeusPrint | Logs into Chat
    net.Receive("ToEVE_DeusPrint",function()
        local Activator = net.ReadEntity()
        local Action = net.ReadString()
        local Target = net.ReadString()

        local _Activator
        local _Target

        if Activator:GetClass() != "worldspawn" then
            _Activator = Activator:Nick()
        else
            _Activator = "CONSOLE"
        end

        if !player.GetBySteamID(Target) then
            _Target = Target
        else
            _Target = player.GetBySteamID(Target):Nick()
        end

        DEUSCOLOR = Color(155,255,255)
        DEUS_ACTIONCOLOR = Color(255,255,255)
        DEUS_PLYCOLOR = Color(0,255,0)

        chat.AddText(DEUSCOLOR,"[DEUS] ", DEUS_PLYCOLOR, _Activator .. " ", DEUS_ACTIONCOLOR, Action .. " ", DEUS_PLYCOLOR, _Target .. " ")
    end)
end