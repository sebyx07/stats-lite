# StatsLite

Simple way to get server information as json. Easy to extend with a `config.rb` file.
Embeddable in Rails

### Standalone usage

Requirements ruby, min version 2


```shell_script
sudo apt-get install -y ruby build-essential ruby-dev
```

Usage standalone, you might need to run some commands as __sudo__.


```shell_script
gem install stats_lite --no-ri --no-rdoc
stats-lite
curl http://localhost:9111
```

Add to startup, crontab


```shell_script
crontab -e
# then add
@reboot /usr/local/bin/stats-lite /home/deploy/.stats-lite/config.rb
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

```shell_script
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
  s.port ENV["STATS_LITE_PORT"] # defaults to 9111

  s.data -> (data) do # add more data
    data[:ruby_current_time] = Time.now # simple value
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


  s.rack do   # use rack builder, it's also password protected from above^
    map "/rack" do
      run lambda { |env| [200, {'Content-Type' => 'text/plain'}, ['OK']] }
    end
  end

  s.cron do |rufus| # uses the Rufus scheduler, more details here https://github.com/jmettraux/rufus-scheduler
    rufus.every "5s" do
      print "\n cron job"
    end
    rufus.every "1h" do
      print "\n hourly cron job"
    end
  end
end
```