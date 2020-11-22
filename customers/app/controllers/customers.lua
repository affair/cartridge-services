local log = require("log").info
local error = require("log").error
local httpd = require('cartridge').service_get('httpd')
local metrics = require'metrics'.enable_default_metrics()
local Util = require('app.utils.util')
local json = require("json")
local CustomersModel = require("app.models.customers")

function http_create_customer(req)

    local body = req:json()

    if tonumber(body.customer_id) == nil then
        return { status = 500, body = json.encode({ message = "customer_id is invalid" }) }
    end
    if body.name == nil then
        return { status = 500, body = json.encode({ message = "title is invalid" }) }
    end

    local ret, data = CustomersModel.create(
        tonumber(body.customer_id), 
        body.name 
    )

    if not ret then
        return { status = 500, body = json.encode({ message = "Can't add code" }) }
    end

    return { status = 200 }
end

function http_lookup_customer(req)

    if tonumber(req:query_param('customer_id')) == nil then
        return { status = 500, body = json.encode({ message = "customer_id is invalid" }) }
    end

    local ret, codes = CustomersModel.lookup( tonumber(req:query_param('customer_id')) )

    if not ret then
        return { status = 500, body = json.encode({ message = "Can't request codes by partner" }) }
    end

    return {
        status = 200,
        body = json.encode(Util.formatItem(codes, "customers"))
    }
end

local function init(opts) -- luacheck: no unused args
    log("+OK - init. opts: ", Util.dump(opts))
    
    if opts.is_master then
        box.schema.user.grant('guest',
            'read,write,execute',
            'universe',
            nil, { if_not_exists = true }
        )
    end

    if not httpd then
        return nil, err_httpd:new("not found")
    end

    -- assigning handler functions
    httpd:route({ path = '/create', method = 'POST', public = true }, 
        http_create_customer
    )

    httpd:route({ path = '/lookup', method = 'GET', public = true }, 
        http_lookup_customer
    )

    httpd:route({ path = '/metrics' }, require('metrics.plugins.prometheus').collect_http)

    return true
end

local function stop()
end

local function validate_config(conf_new, conf_old) -- luacheck: no unused args
    return true
end

local function apply_config(conf, opts) -- luacheck: no unused args
    -- if opts.is_master then
    -- end

    return true
end

return {
    role_name = 'app.controllers.customers',
    init = init,
    stop = stop,
    validate_config = validate_config,
    apply_config = apply_config,
    dependencies = {
        'app.libs.db',
    }
}
