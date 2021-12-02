hook.Add("InitPostEntity", "ToADAM_Heimdall", function()
    net.Start("ToADAM_Heimdall")
    net.SendToServer()
end)