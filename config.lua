local config = require("lapis.config")

config("development", {
  server = "nginx",
  code_cache = "off",
  num_workers = "1",
  postgres = {
    host = "127.0.0.1",
    user = "postgres",
    password = "password",
    database = "my_database"
  },
  opensky = {
    client_id = os.getenv("OPENSKY_CLIENT_ID"),
    client_secret = os.getenv("OPENSKY_CLIENT_SECRET")
  }
})
