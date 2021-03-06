module Cb
  module Responses
    module Spot

      class Retrieve < Responses::ApiResponse

        protected

        def validate_api_hash
          required_response_field(root_node, response)
          required_response_field(spot_collection, response[root_node])
        end

        def extract_models
          spot_hashes.map { |spot_data| Cb::Models::Spot.new(spot_data) }
        end

        def hash_containing_metadata
          response[root_node]
        end

        private

        def root_node
          @root_node ||= 'ResponseRetrieve'
        end

        def spot_collection
          @spot_collection ||= 'SpotData'
        end

        def spot_hashes
          response[root_node][spot_collection]
        end
      end

    end
  end
end
