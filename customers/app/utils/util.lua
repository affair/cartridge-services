local log = require("log").info
local config = require("app.config.config")
local json = require("json")

function dump(val, name, skipnewlines, depth)
    
    skipnewlines = skipnewlines or false
    depth = depth or 0

    local tmp = string.rep(" ", depth)

    if name then tmp = tmp .. name .. " = " end

    if type(val) == "table" then
        tmp = tmp .. "{" .. (not skipnewlines and "\n" or "")

        for k, v in pairs(val) do
            tmp =  tmp .. dump(v, k, skipnewlines, depth + 1) .. "," .. (not skipnewlines and "\n" or "")
        end

        tmp = tmp .. string.rep(" ", depth) .. "}"
    elseif type(val) == "number" then
        tmp = tmp .. tostring(val)
    elseif type(val) == "string" then
        tmp = tmp .. string.format("%q", val)
    elseif type(val) == "boolean" then
        tmp = tmp .. (val and "true" or "false")
    elseif type(val) == "nil" then
        tmp = tmp .. "null"
    else
        tmp = tmp .. "\"[inserializeable datatype:" .. type(val) .. "]\""
    end

    return tmp
end

Util = {}
Util.forceDump = dump

function Util.dump(val, name, skipnewlines, depth)
    -- if config.db.box_cfg.log_level < 5 then return "" end

    return dump(val, name, skipnewlines, depth)
end

function Util.formatList(list, space)
    local result = {}
    for i, item in ipairs(list) do
        table.insert(result, Util.formatItem(item, space))
    end

    if #result == 0 then  result = json.empty_array end

    return result
end

function Util.formatItem(item, space)
    if item == nil then return {} end
    if config.db.format[space] == nil then return {} end 
    
    local space_format = config.db.format[space]
    local result = {}

    for field, idx in pairs(space_format) do
        result[field] = item[idx]
    end

    return result
end

return Util