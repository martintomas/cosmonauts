# frozen_string_literal: true

require "rails_helper"

RSpec.configure do |config|
  config.openapi_root = Rails.root.join("swagger").to_s

  config.after :each, generate_swagger_example: true do |example|
    example.metadata[:response][:content] = {
      "application/json" => {example: JSON.parse(response.body, symbolize_names: true)}
    }
  end

  config.openapi_specs = {
    "v1/swagger.yaml" => {
      openapi: "3.0.1",
      info: {
        title: "API V1",
        version: "v1"
      },
      paths: {},
      components: {
        securitySchemes: {},
        schemas: {
          cosmonaut: {
            type: :object,
            properties: {
              id: {type: :string},
              type: {type: :string},
              attributes: {
                type: :object,
                properties: {
                  first_name: {type: :string},
                  last_name: {type: :string},
                  mental_endurance: {type: :string},
                  physical_condition: {type: :string}
                },
                required: %w[first_name last_name mental_endurance physical_condition]
              }
            },
            required: %w[id type attributes]
          }
        }
      },
      servers: [
        {
          url: "{scheme}://{host}",
          variables: {
            scheme: {
              default: "http"
            },
            host: {
              default: "localhost:3000"
            }
          }
        }
      ]
    }
  }

  config.openapi_format = :yaml
end
