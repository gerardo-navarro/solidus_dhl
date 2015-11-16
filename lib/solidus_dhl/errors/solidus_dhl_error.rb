module SolidusDhl
  module Errors
    class SolidusDhlError

      attr_reader :message
      
      def initialize(message)
        @message = message
      end

      def status
        500
      end

      def to_hash
        {
          meta: {
            code: status,
            message: message
          }
        }
      end

      def to_json(*)
        to_hash.to_json
      end
    end
  end
end