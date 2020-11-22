local log = require("log").info
local error = require("log").error
local checks = require('checks')
local Util = require('app.utils.util')

local Customers = {}

function Customers.initSpace(opts)

    log("+OK - Customers.initSpace. opts: %s", Util.dump(opts))

    if opts.is_master then
        local customers = box.schema.space.create(
            -- name of the space for storing partner codes
            'customers',
            -- extra parameters
            {
                -- engine vinyl
                engine = 'vinyl',

                -- format for stored tuples
                format = {
                    {'customer_id', 'unsigned'},
                    {'name',        'string'}
                },
                -- creating the space only if it doesn't exist
                if_not_exists = true,
            }
        )

        -- creating a primary index by code field
        customers:create_index('primary', {
            parts = {'customer_id'},
            if_not_exists = true
        })
    end
end

function Customers.create(customer_id, name)
    checks('number', 'string')

    return pcall(function()
        return box.space.customers:insert({ customer_id, name })
    end)
end

function Customers.lookup(customer_id)
    checks('number')

    return pcall(function()
        return box.space.customers:select(customer_id)[1]
    end)
end

return Customers