hook.Add("OnParanoidDetection", "Paranoid/Guthlog/OnParanoidDetection", function(ply, rule)
    print("Paranoid: " .. ply:Nick() .. "(" .. ply:SteamID() .. ") detected breaking rule " .. rule)
end)

hook.Add("OnParanoidTreatment", "Paranoid/Guthlog/OnParanoidTreatment", function(ply, rule)
    print("Paranoid: " .. ply:Nick() .. "(" .. ply:SteamID() .. ") received treatment")
end)