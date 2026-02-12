local http = require("lapis.http")
local ltn12 = require("ltn12")
local json = require("cjson")
local config = require("lapis.config").get()

local OpenSkyService = {}

-- simple url-encoder for form values
local function urlencode(str)
    if not str then return "" end
    str = tostring(str)
    return (str:gsub("([^%w%-._~])", function(c) return string.format("%%%02X", string.byte(c)) end))
end

local token_cache = { access_token = nil, expiry = 0 }

local function get_token()
    if token_cache.access_token and os.time() < token_cache.expiry then
        return token_cache.access_token, nil
    end

    local token_url = "https://auth.opensky-network.org/auth/realms/opensky-network/protocol/openid-connect/token"
    local body = "grant_type=client_credentials"
        .. "&client_id=" .. urlencode(config.opensky.client_id)
        .. "&client_secret=" .. urlencode(config.opensky.client_secret)

    local out = {}
    local _, status = http.request({
        method = "POST",
        url = token_url,
        headers = {
            ["Content-Type"] = "application/x-www-form-urlencoded",
        },
        source = ltn12.source.string(body),
        sink = ltn12.sink.table(out),
    })
    local resp_body = table.concat(out)

    if status ~= 200 then
        return nil, "Failed to fetch access token: " .. tostring(status) .. " - " .. tostring(resp_body)
    end

    local ok, data = pcall(json.decode, resp_body)
    if not ok or not data or not data.access_token then
        print("Failed to decode token response:", resp_body)
        return nil, "Failed to decode token response: " .. tostring(resp_body)
    end

    -- expires_in is seconds; add small buffer
    local ttl = tonumber(data.expires_in) or 1800
    token_cache.access_token = data.access_token
    token_cache.expiry = os.time() + ttl - 30

    return token_cache.access_token, nil
end

function OpenSkyService.get_all_states()
    local token, err = get_token()
    if not token then
        print("Error getting token:", err)
        return nil, err
    end

    local url = "https://opensky-network.org/api/states/all"
    local out = {}
    local _, status = http.request({
        url = url,
        headers = {
            Authorization = "Bearer " .. token,
        },
        sink = ltn12.sink.table(out),
    })
    local resp_body = table.concat(out)

    if status ~= 200 then
        return nil, "Failed to fetch flight data: " .. tostring(status) .. " - " .. tostring(resp_body)
    end

    local ok, data = pcall(json.decode, resp_body)
    if not ok then
        print("Failed to parse JSON response")
        return nil, "Failed to parse JSON response"
    end

    print("Parsed data type:", type(data))
    print("Data.states type:", type(data.states))
    if data.states then
        print("Number of states:", #data.states)
    end

    return data.states, nil
end

return OpenSkyService