local Flow = require("lapis.flow").Flow
local http = require("lapis.http")
local ltn12 = require("ltn12")
local json = require("cjson")

local MapFlow = Flow:extend({
    expose_assigns = true,
    render_map = function(self)
        -- a simple GET request
        local body, status_code, headers = http.request("https://opensky-network.org/api/states/all")
        
        if status_code == 200 then
            -- Decode the JSON response
            local data = json.decode(body)
            
            -- Access the states
            local states = data.states
            
            -- Now you can pass states to your view
            self.flight_data = json.encode(states)
        else
            -- Handle error
            self.flight_data = {
                error = "Failed to fetch flight data",
                status = status_code
            }
        end
        
        return { render = "map" }
    end
})

return MapFlow