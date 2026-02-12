local Flow = require("lapis.flow").Flow
local json = require("cjson")
local OpenSkyService = require("services.opensky")

local MapFlow = Flow:extend({
    expose_assigns = true,
    render_map = function(self)
        local states, err = OpenSkyService.get_all_states()

        if err then 
            self.flight_data = json.encode({ error = err })
        else
            self.flight_data = json.encode(states)
        end
        
        return { render = "map" }
    end
})

return MapFlow