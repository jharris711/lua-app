local lapis = require("lapis")
local config = require("lapis.config").get()
local respond_to = require("lapis.application").respond_to
local app = lapis.Application()

app:enable("etlua")

app.layout = require "views.layout"

require("routes")(app)

return app
