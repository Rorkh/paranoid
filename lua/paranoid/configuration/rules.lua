paranoid.register_rule("OnlinePlayer", {
    callback = function(value)
        return IsValid(player.GetByID(value))
    end
})

paranoid.register_rule("Range", {
    callback = function(value, args)
        return value >= args.min and value <= args.max
    end
})

paranoid.register_rule("OneOf", {
    callback = function(value, args)
        for _, v in ipairs(args) do
            if v == value then
                return true 
            end             
        end

        return false
    end
})

paranoid.register_rule("Function", {
    callback = function(value, arg)
        return _G[arg](value)
    end
})

paranoid.register_alias("ValidEntity", {
    base = "Entity",
    rules = {
        {
            name = "Function",
            args = "IsValid"
        }
    }
})