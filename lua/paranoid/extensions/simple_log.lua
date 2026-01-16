print("simple log init")

hook.Add("OnParanoidDetection", "Paranoid/SimpleLog/OnParanoidDetection", function(ply, rule)
    print("Paranoid: " .. ply:Nick() .. " (" .. ply:SteamID() .. ") detected breaking rule " .. rule)
end)

hook.Add("OnParanoidTreatment", "Paranoid/SimpleLog/OnParanoidTreatment", function(ply, rule)
    print("Paranoid: " .. ply:Nick() .. " (" .. ply:SteamID() .. ") received treatment")
end)