local http = require("lapis.http")
local json = require("cjson")

local OpenSkyService = {}

function OpenSkyService.get_all_states()
    local body, status_code, headers = http.request("https://opensky-network.org/api/states/all")

    if status_code ~= 200 then
        return nil, "Failed to fetch flight data: " .. tostring(status_code)
    end

    local success, data = pcall(json.decode, body)
    if not success then
        return nil, "Failed to parse JSON response"
    end

    return data.states, nil
end

return OpenSkyService