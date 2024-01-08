module API
  module V1
    class CosmonautSerializer
      include JSONAPI::Serializer

      attributes :first_name, :last_name, :mental_endurance, :physical_condition
    end
  end
end
