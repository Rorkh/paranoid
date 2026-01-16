-- Table of extension names that should be enabled
paranoid.config.extensions = {"simple_log"}

-- Maximum number of times a user can fail security checks until receiving treatment
paranoid.config.tolerance = 0

-- Callback that should be executed when player found breaking rules
-- First argument is player object
paranoid.config.treatment = function(ply)
    ply:Kick()
end