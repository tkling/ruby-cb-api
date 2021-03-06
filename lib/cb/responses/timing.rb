module Cb
  module Responses

    class Timing
      attr_reader :response_sent, :elapsed

      def initialize(response)
        @response = response
        post_initialize
      end

      private
      attr_reader :response

      def post_initialize
        raise_on_empty_timing_info
        @response_sent = parsed_response_sent
        @elapsed       = parsed_time_elapsed
      end

      def raise_on_empty_timing_info
        should_raise = response.nil? || !response.respond_to?(:[])
        raise ExpectedResponseFieldMissing.new('Missing/malformed timing info!') if should_raise
      end

      def parsed_response_sent
        DateTime.parse(response['TimeResponseSent']) rescue DateTime.new
      end

      def parsed_time_elapsed
        response.include?('TimeElapsed') ? response['TimeElapsed'].to_f : nil
      end
    end

  end
end
