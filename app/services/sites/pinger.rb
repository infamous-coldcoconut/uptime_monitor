require "net/http"

module Sites
    class Pinger
      # výsledek - neměnitelný
      Result = Data.define(:status_code, :response_time_ms, :success, :error_message)

      def self.call(site)
          new(site).call
      end

      def initialize(site)
          @site = site
          @uri = URI.parse(site.url)
      end

      def call
        status_code = nil
        elapsed_ms = 0
        error_message = nil

        begin
          http = Net::HTTP.new(@uri.host, @uri.port)
          http.use_ssl = (@uri.scheme == "https")
          http.open_timeout = 5
          http.read_timeout = 5

          # měření odezvy v ms
          start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
          response = http.request_get(@uri.request_uri.presence || "/")
          end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)

          elapsed_ms = ((end_time - start_time)*1000).round
          status_code = response.code.to_i

        rescue StandardError => e
          error_message = e.message
        end

        Result.new(
          status_code: status_code,
          response_time_ms: elapsed_ms,
          success: (status_code == @site.expected_status),
          error_message: error_message
        )
      end
    end
end
