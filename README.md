# StatsLite

Simple way to get server information as json. Easy to extend with a `config.rb` file.
Embeddable in Rails

### Standalone usage

Requirements ruby, min version 2

```shell script
gem install stats_lite
stats-lite
curl http://localhost:9111
```

![demo](https://raw.githubusercontent.com/sebyx07/stats-lite/master/docs/example.png)

create a `config.rb` then `stats-lite`

```ruby 
# example config.rb
# basic usage

StatsLite.configure do |s|
  s.password "1234" # password protection
  s.port 9111 # listening port
end
```

```shell script
# now it's protected by passowrd
curl http://localhost:9111?password=1234 
```

### Rails usage

`gem "stats_lite"`

```ruby
# routes.rb
mount StatsLite::App => "/server-stats" 
```

### Advanced configuration

```ruby

StatsLite.configure do |s, h|
  s.password ENV["STATS_LITE_PASS"] # defaults to nil, unprotected
  s.port ENV["STATS_LITE_PORT"], defaults to 9111

  s.data -> (data) do # add more data
    data[:ruby_current_time] = Time.now #simple value
    data[:linux_time] = h.command("date") # bash command, supports {cache: true, expires_in: 60} 

    data[:slow_command] = h.fetch :slow_command, -> {
      sleep 1
      "slow command"
    }, expires_in: 5 # cached ruby value
  end

  s.app do |sinatra| # extend the app, add multiple routes, which are protected by the password
    sinatra.get("/another_route") do
      content_type :json

      { cpus: h.command("nproc", { cache: true }) }.to_json
    end
  end
end
```