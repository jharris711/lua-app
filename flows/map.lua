local Flow = require("lapis.flow").Flow

local MapFlow = Flow:extend({
    render_map = function(self)
        return { render = "map" }
    end
})

return MapFlow