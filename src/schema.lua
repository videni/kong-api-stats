local Errors = require "kong.dao.errors"

return {
    fields = {
        influxdb_host = {type = "string"},
        influxdb_port = {type = "number"},
        influxdb_proto = {type = "string"},
        influxdb_db = {type = "string"},
        influxdb_username = {type = "string"},
        influxdb_password = {type = "string"},
        influxdb_measurement = {type = "string"},

        redis_host = { type = "string" },
        redis_port = { type = "number", default = 6379 },
        redis_password = { type = "string" },
        redis_timeout = { type = "number", default = 2000 },
    },
    self_check = function(schema, plugin_t, dao, is_update)
        if not plugin_t.host or #plugin_t.host == 0 then
            return false, Errors.schema "you must provide the InfluxDB host"
        end

        if not plugin_t.port or plugin_t.port == 0 then
            return false, Errors.schema "you must provide the InfluxDB port"
        end

        if not plugin_t.db or #plugin_t.db == 0 then
            return false, Errors.schema "you must provide the InfluxDB db"
        end

        if not plugin_t.redis_host or plugin_t.redis_host == 0 then
            return false, Errors.schema "you must provide the Redis port"
        end

        if not plugin_t.redis_port or #plugin_t.redis_port == 0 then
            return false, Errors.schema "you must provide the Redis port"
        end

        return true
    end
}