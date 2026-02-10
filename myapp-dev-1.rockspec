package = "myapp"
version = "dev-1"

source = { url = "file://.", dir = "." }

description = {
   summary = "A small Lapis application",
   detailed = [[
      Demo Lapis application using Leaflet. This rockspec is for
      development and installs runtime dependencies only.
   ]],
   homepage = "https://example.com",
   license = "MIT"
}

dependencies = {
   "lapis >= 1.17.0",
   "pgmoon >= 1.15",
   "bcrypt >= 2.1",
   "luasocket >= 3.1.0"
}

build = {
   type = "none"
}
