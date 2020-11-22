local log = require("log").info
local error = require("log").error
local cartridge = require('cartridge')
local checks = require('checks')
local Util = require('app.utils.util')

local function init(opts) -- luacheck: no unused args
    log("+OK - init. opts: ", Util.dump(opts))

    require("app.models.customers").initSpace(opts)

    return true
end

local function stop()
    log("+OK - init")
end

local function validate_config(conf_new, conf_old) -- luacheck: no unused args
    log("+OK - validate_config")
    return true
end

local function apply_config(conf, opts) -- luacheck: no unused args
    log("+OK - apply_config")
    
    -- if opts.is_master then
    -- end
    return true
end

return {
    role_name = 'app.roles.libs.db',
    init = init,
    stop = stop,
    validate_config = validate_config,
    apply_config = apply_config
}
