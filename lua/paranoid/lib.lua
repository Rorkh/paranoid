if not SERVER then return end

-- netstream
local function get_locals(level)
    local locals = {}
    local i = 1

    while (true) do
        local name, value = debug.getlocal(level, i)
        if name == nil then break end

        locals[name] = value
        i = i + 1
    end

    return locals
end

function paranoid_test()
    return false
end

paranoid.rules = paranoid.rules or {}
paranoid.aliases = paranoid.aliases or {}

function paranoid.register_rule(name, definition)
    paranoid.rules[name] = definition
end

function paranoid.register_alias(alias, compound)
    paranoid.aliases[alias] = compound
end

function paranoid.execute_rule(rule, value)
    local rule_definition, rule_name = nil, nil
    local args = {}

    if type(rule) == "string" then
        rule_name = rule
        rule_definition = paranoid.rules[rule_name]
    else
        rule_name = rule.name
        rule_definition = paranoid.rules[rule_name]
        args = rule.args and rule.args or {}
    end

    if not rule_definition then
        ErrorNoHaltWithStack("Paranoid: Trying to apply invalid rule " .. rule_name)
        -- Silent fail
        return
    end

    if not rule_definition.callback(value, args) then
        local net_arguments = get_locals(5)

        hook.Run("OnParanoidDetection", net_arguments.client, rule_name)

        if paranoid.config.treatment then
            hook.Run("OnParanoidTreatment", net_arguments.client)
            paranoid.config.treatment(net_arguments.client)
        end

        return false
    end
end

function paranoid.expect(compound)
    if type(compound) == "string" then
        compound = paranoid.aliases[compound]
    end

    compound.base_args = compound.base_args or {}
    compound.rules = compound.rules or {}

    local value = net['Read' .. compound.base](
        unpack(compound.base_args)
    )

    local result = true

    for _, rule in ipairs(compound.rules) do
        local execution_result = paranoid.execute_rule(rule, value)
        if execution_result == false then
            return false
        end
    end

    return value
end