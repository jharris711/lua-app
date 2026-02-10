local M = {}

function M.index(self)
  return { redirect_to = self:url_for("map") }
end

return M