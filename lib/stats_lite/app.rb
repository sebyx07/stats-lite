# frozen_string_literal: true

module StatsLite
  class App < Sinatra::Base
    before do
      password = params[:password] || request.cookies["stats_lite_password"]
      conf_pass = StatsLite.configure.password

      if conf_pass && conf_pass != password
        if session[:stats_lite_password]
          session[:stats_lite_password] = nil
        end
        next halt 404, { "Content-Type" => "text/plain" }, ""
      end

      unless session[:stats_lite_password]
        set_session(password)
      end
    end

    def set_session(password)
      response.set_cookie "stats_lite_password", password
    end

    get "/" do
      content_type :json

      result.to_json
    end

    private
      def result
        default = Default
        result = {
          time_utc: Time.now.utc.strftime("%e %b %Y %H:%M:%S%p").strip,
          host: default.host,
          cpu: default.cpu,
          ram: default.ram,
          hdd: default.hdd
        }

        data = StatsLite.configure.data
        data.call(result) if data
        result
      end
  end
end
