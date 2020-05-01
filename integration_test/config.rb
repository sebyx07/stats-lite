# frozen_string_literal: true

StatsLite.configure do |s, h|
  s.password "1234"
  s.port 3000

  s.data -> (data) do
    data[:ruby_current_time] = Time.now
    data[:linux_time] = h.command("date")

    data[:slow_command] = h.fetch :slow_command, -> {
      sleep 1
      "SLOW1233"
    }, expires_in: 5
  end

  s.app do |sinatra|
    sinatra.get("/another_route") do
      content_type :json

      { cpus: h.command("nproc") }.to_json
    end
  end

  s.rack do
    map "/rack" do
      run lambda { |env| [200, { "Content-Type" => "text/plain" }, ["OK"]] }
    end
  end

  s.cron do |rufus|
    rufus.every "5s" do
      print "\ncron job"
    end
  end
end
