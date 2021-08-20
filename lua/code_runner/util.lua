local util = {}

function util.tcopy(src)
    local lookup_table = {}
    local function _copy(src)
        if type(src) ~= 'table' then
            return src
        elseif lookup_table[src] then
            return lookup_table[src]
        end
        local new_table = {}
        lookup_table[src] = new_table
        for k,v in pairs(src) do
            new_table[_copy(k)] = _copy(v)
        end
        return setmetatable(new_table, getmetatable(src))
    end
    return _copy(src)
end

return util
