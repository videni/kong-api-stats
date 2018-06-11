local BasePlugin = require "kong.plugins.base_plugin"
local buffer = require "kong.plugins.apistats.buffer"

local function influxdb_point(ngx, conf)
  local var = ngx.var
  local ctx = ngx.ctx
  local authenticated_credential = ctx.authenticated_credential
  local measurement = conf.measurement or "kong"

  return {
      measurement = measurement,
      tag = {
        uri = var.uri,
        tenant_id = authenticated_credential and authenticated_credential.consumer_id
      },
      field = {
        value = 1
      },
      timestamp = (ngx.now() * 1000)
    }
end

local FLUSH_DELAY = 60

local function flushHandler(premature)
    if premature == true then return end

    buffer.flush()

    local ok, err = ngx.timer.at(FLUSH_DELAY, flushHandler)
    if not ok then
        ngx.log(ngx.ERR, "failed to create the timer: ", err)
    end
end

local ApiStats = BasePlugin:extend()

ApiStats.PRIORITY = 992
ApiStats.flushHandlerRunning = false

function ApiStats:new()
    ApiStats.super.new(self, "apistats")
end

function ApiStats:log(conf)
    ApiStats.super.log(self)

    local ok, err = buffer.init({
        host = conf.host,
        port = conf.port,
        proto = conf.proto,
        db = conf.db,
        auth = conf.username and conf.password and conf.username.. ":" ..conf.password or Nil
    })

    if (not ok) then
        ngx.log(ngx.ERR, err)
        return false
    end

    ApiStats.setupFlushHandler()

    local point = influxdb_point(ngx, conf)
    buffer.buffer(point)

    return true, point
end

function ApiStats:setupFlushHandler()
    if ApiStats.flushHandlerRunning == true then return end
    ApiStats.flushHandlerRunning = true

    local ok, err = ngx.timer.at(FLUSH_DELAY, flushHandler)
    if not ok then
        ngx.log(ngx.ERR, "failed to create the timer: ", err)
    end
end

return ApiStats
