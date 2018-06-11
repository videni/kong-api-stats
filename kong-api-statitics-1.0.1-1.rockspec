package = "kong-api-statistics"
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
    ["kong.plugins.influxdb.handler"] = "src/handler.lua",
    ["kong.plugins.influxdb.schema"] = "src/schema.lua",
    ["kong.plugins.influxdb.buffer"] = "src/buffer.lua",
    ["kong.plugins.influxdb.http"] = "src/http.lua"
  }
}
