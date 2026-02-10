local index = require "controllers.index"
local map = require "controllers.map"

return function(app)
  app:match("index", "/", index.index)
  app:match("map", "/map", map.map)
end