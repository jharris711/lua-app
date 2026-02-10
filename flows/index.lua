local Flow = require("lapis.flow").Flow

local IndexFlow = Flow:extend({
    render_home_page = function(self)
        return { redirect_to = self:url_for("map") }
    end
})

return IndexFlow