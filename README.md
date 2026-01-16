
# Paranoid

Zero tolerance security library for Garry's Mod

## Usage

That library allows you to server-side filter values you receive from net.ReceiveX functions and execute immediate action if filter is not passed via mechanism of rules and exception compounds.

## Real life examples

### ATM
You have an ATM GUI that allows you to transfer money from owner account to someone else.

To make this work nice, you need to add clientside and serverside checks if owner has right amount of money. While clientside check is not in question, you doesn't want any flaws serverside.

Without this library you can write something like this:

```lua
net.Receive("atm_transfer", function(_, ply)
    local target = net.ReadPlayer()

    local amount = net.ReadUInt(32)
    if amount > ply:Money() or amount <= 0 then return end

    do_transfer(ply, target, amount)
end)
```

And it's looks fine. But the player with malicious intents can try to transfer ungodly amount of money he don't have using direct net.SendToServer call via autorun-rs or any similar libraries and we can not detect it without extra bloat or custom solutions.

But this library promotes it, bloat free and with optional execution ("treatment"). Let's rewrite the code using it to execute all hackers.

```lua
net.Receive("atm_transfer", function(_, ply)
    local target = net.ReadPlayer()

    local amount = paranoid.expect({
        base = "UInt",
        base_args = {32},
        rules = {
            {
                name = "Range",
                args = {min = 0, max = ply:Money()}
            }
        }
    })

    if not amount then return end
    do_transfer(ply, target, amount)
end)
```

I guess, you have noticed the paranoid.expect call. It takes "compound" (or compound alias) that describes what data type should be read and what filters received value should pass to be considered valid. In case the value is not valid, you will receive false instead of it.

But it's not all the paranoid does. Also you will receive a log (depending on installed extensions. Example with guthlog extension below) about malicious value provided.

![alt text](https://i.imgur.com/Qe5HlQr.png)


Besides that, you can configure the library to immediately ban the player breaking rules.

The only problem you might notice, it's not exactly bloat free because the library can't logically handle all such cases in one line without any extra input from developer.

But it's provides the solution to do it. For it, we need to register our custom "simple" rule.

```lua
hook.Add("OnParanoidInit", function()
    paranoid.register_rule("ValidMoney", {
        callback = function(value, args)
            return value <= args.client:Money() and amount >= 0
        end
    })
end)
```

And then we can use it in one line using one rule expect notation

```lua
local amount = paranoid.expect("ValidMoney")
```

Magic happens, because paranoid passes the second argument value of net.Receive as client rule argument that we can use in our rule.

While I understand that a library may seem unnecessary as it requires extra effort, but with set of rules defined you can do a truly unbreakable system (addon or gamemode) that will immediately punish users that try to exploit it's code.

## Configuration and punishment in question

This library provides configuration options for enabling extensions and choosing an execution option.

```lua
-- Table of extension names that should be enabled
-- Available: guthlog, simple_log
paranoid.config.extensions = {"guthlog"}

-- Maximum number of times a user can fail security checks until receiving treatment
paranoid.config.tolerance = 0

-- Callback that should be executed when player found breaking rules
-- First argument is player object
paranoid.config.treatment = function(ply)
    ply:Kick()
end
```

