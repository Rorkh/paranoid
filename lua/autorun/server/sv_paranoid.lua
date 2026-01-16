paranoid = paranoid or {config = {}}

include("paranoid/lib.lua")

include("paranoid/configuration/config.lua")
include("paranoid/configuration/rules.lua")

for _, extension in ipairs(paranoid.config.extensions) do
    include("paranoid/extensions/" .. extension .. ".lua")
end

hook.Run("OnParanoidInit")