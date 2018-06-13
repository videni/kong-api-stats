# kong-api-stats

- [x] 采用influxdb统计调用次数
    - [x] 处理dynamic path segments。 在infuxdb中存储匹配的API名称
    - [x] CQ and Retention Policy
- [x] 统计每个租户每个API每日调用次数
- [ ] 使用Redis记录每个租户每个API月调用次数
- [ ] 调用限制。
    - [ ] 1. 当API调用次数超过月调用限制时。
    - [ ] 2. 当租户服务过期时。
    - [ ] 3. 租户API调用权限， 只有具备权限才能调用
- [ ] API计费设置

##  安装
```
luarocks install kong-api-stats
```

##  配置

```
$ curl -X POST http://kong:8001/apis/{api}/plugins \
    --data "name=kong-influxdb" \
    --data "config.host: http://myinfluxdb.com" \
    --data "config.port: 8086" \
    --data "config.db: myDB" \
    --data "config.username: myUsername" \
    --data "config.password: myPassword" \
    --data "config.measurement: myMeasurement" \
    --data "config.client_ip_header: MyHeader"
```

| 参数  | 描述 |
| ------------- | ------------- |
| `name`  | Name of the plugin: `kong-api-stats`  |
| `config.host` | InfluxDB host  |
| `config.port`  | InfluxDB port  |
| `config.db`  | The db in InfluxDB to push the metrics to  |
| `config.username`  | Username to authenticate against InfluxDB if required |
| `config.password`  | Password to authenticate against InfluxDB if required  |
| `config.measurement`  | The name of the measurement to push metrics to; defaults to `kong`  |