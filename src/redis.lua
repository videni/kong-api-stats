local restyRedis = require "resty.redis"

local redis = {}

function redis.connect(conf)
	local red = restyRedis:new()
	red:set_timeout(conf.redis_timeout)
	local ok, err = red:connect(conf.redis_host, conf.redis_port)
	if not ok then
	  ngx_log(ngx.ERR, "failed to connect to Redis: ", err)
	  return nil, err
	end

	local times, err = red:get_reused_times()
	if err then
	  ngx_log(ngx.ERR, "failed to get connect reused times: ", err)
	  return nil, err
	end

	if times == 0 and conf.redis_password and conf.redis_password ~= "" then
	  local ok, err = red:auth(conf.redis_password)
	  if not ok then
	    ngx_log(ngx.ERR, "failed to auth Redis: ", err)
	    return nil, err
	  end
	end

	return red
end

return  redis

