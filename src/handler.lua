local BasePlugin = require "kong.plugins.base_plugin"
local buffer = require "kong.plugins.apistats.buffer"
local redis = require "kong.plugins.apistats.redis"

local function influxdb_point(ngx, conf)
  local var = ngx.var
  local ctx = ngx.ctx
  local measurement = conf.measurement or "kong"

  return {
      measurement = measurement,
      tag = {
        api_name = ctx.api.name,
        tenant_id = getCustomerId()
      },
      field = {
        uri = ctx.router_matches.uri,
        raw_uri = var.uri
      },
      timestamp = (ngx.now() * 1000)
    }
end

local FLUSH_DELAY = 5

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

function ApiStats:access(conf)
    ApiStats.super.access(self)

    if shouldBypass() then return end

    local red = redis.connect(conf);

    if red == nil then return end

    red:hincrby(getKey(getCustomerId(), ngx.ctx.api.name), os.date("%Y%m%d", os.time())), 1);
end

local function getKey(customerId, apiName)
  return 'customer:'..customer..':api_name:'..apiName
end

local function shouldBypass()
    -- no api found, and exclude '/'
    if ngx.ctx.api == nil  or ngx.var.uri == '/' then return false end

    if getCustomerId() == nil return false end

    return true
end

local function getCustomerId()
   local authenticated_credential = ngx.ctx.authenticated_credential

   return authenticated_credential ?  authenticated_credential.consumer_id : nil
end

function ApiStats:log(conf)
    ApiStats.super.log(self)

    if shouldBypass() then return end

    local ok, err = buffer.init({
        host = conf.influxdb_host,
        port = conf.influxdb_port,
        proto = conf.influxdb_proto,
        db = conf.influxdb_db,
        auth = conf.influxdb_username and conf.influxdb_password and conf.influxdb_username.. ":" ..conf.influxdb_password or Nil
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
