package = "kong-apistats"
version = "1.0.1-1"
source = {
  url = "none",
  tag = "1.0.1"
}
description = {
  summary = "A plugin for Kong to count api calls",
  homepage = "none",
  license = "Apache 2.0"
}
dependencies = {
  "lua >= 5.1"
}
build = {
  type = "builtin",
  modules = {
    ["kong.plugins.apistats.handler"] = "src/handler.lua",
    ["kong.plugins.apistats.schema"] = "src/schema.lua",
    ["kong.plugins.apistats.buffer"] = "src/buffer.lua",
    ["kong.plugins.apistats.http"] = "src/http.lua",
    ["kong.plugins.apistats.daos"] = "src/daos.lua",
    ["kong.plugins.apistats.redis"] = "src/redis.lua",
    ["kong.plugins.apistats.migrations.postgres"] = "src/postgres.lua"
  }
}