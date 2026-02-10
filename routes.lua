local capture_errors = require("lapis.application").capture_errors

return function(app)
  app:match("index", "/", capture_errors(function(self)
    return self:flow("index"):render_home_page()
  end))
  app:match("map", "/map", capture_errors(function (self)
    return self:flow("map"):render_map()
  end))
end