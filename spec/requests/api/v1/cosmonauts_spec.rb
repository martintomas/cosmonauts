require "swagger_helper"

RSpec.describe "API V1 Cosmonauts", type: :request do
  path "/api/v1/cosmonauts" do
    get "Returns list of the cosmonauts" do
      tags "Cosmonauts"
      consumes "application/json"
      produces "application/json"
      parameter name: "limit", in: :query, type: :number, description: "Limit number of cosmonauts", required: false

      let!(:cosmonauts) { create_list :cosmonaut, 15 }

      response "200", :success do
        schema type: :object, properties: {
          data: {type: :array, items: {"$ref" => "#/components/schemas/cosmonaut"}}
        }

        run_test!

        it "matches snapshot", generate_swagger_example: true do
          expect(response.body).to match_snapshot("api/v1/cosmonauts")
        end

        context "with limit" do
          let(:limit) { 5 }

          it "returns only limited number of records" do
            expect(response_json["data"].size).to eq(limit)
          end
        end
      end
    end

    post "Creates cosmonaut" do
      tags "Cosmonauts"
      consumes "application/json"
      produces "application/json"
      parameter name: :cosmonaut, in: :body, schema: {
        type: :object,
        properties: {
          first_name: {type: :string},
          last_name: {type: :string},
          physical_condition: {type: :string},
          mental_endurance: {type: :string}
        },
        required: ["first_name", "last_name", "physical_condition", "mental_endurance"]
      }

      response "200", :success do
        let(:cosmonaut) { attributes_for :cosmonaut }

        schema type: :object, properties: {
          data: {"$ref" => "#/components/schemas/cosmonaut"}
        }

        run_test!

        it "matches snapshot", generate_swagger_example: true do
          expect(response.body).to match_snapshot("api/v1/create-cosmonaut")
          expect(response_json["data"]["attributes"].symbolize_keys).to eq(cosmonaut)
        end
      end

      response "422", :unprocessable_entity do
        let(:cosmonaut) { attributes_for :cosmonaut, first_name: nil }

        schema type: :object, properties: {
          errors: {type: :object, properties: {first_name: {type: :array, items: {type: :string}}}}
        }

        run_test!

        it "return correct error message" do
          expect(response_json["errors"]["first_name"]).to eq(["can't be blank"])
        end
      end
    end
  end

  path "/api/v1/cosmonauts/{id}" do
    get "Returns appropriate cosmonaut" do
      tags "Cosmonauts"
      consumes "application/json"
      produces "application/json"
      parameter name: :id, in: :path, type: :string, description: "Cosmonaut ID"

      let!(:cosmonaut) { create :cosmonaut }
      let(:id) { cosmonaut.id }

      response "200", :success do
        schema type: :object, properties: {data: {"$ref" => "#/components/schemas/cosmonaut"}}

        run_test!

        it "matches snapshot", generate_swagger_example: true do
          expect(response.body).to match_snapshot("api/v1/get-cosmonaut")
        end
      end

      response "404", :not_found do
        let(:id) { 0 }

        schema type: :object, properties: {errors: {type: :string}}

        run_test!
      end
    end

    put "Updates appropriate cosmonaut" do
      tags "Cosmonauts"
      consumes "application/json"
      produces "application/json"
      parameter name: :id, in: :path, type: :string, description: "Cosmonaut ID"
      parameter name: :cosmonaut, in: :body, schema: {
        type: :object,
        properties: {
          first_name: {type: :string},
          last_name: {type: :string},
          physical_condition: {type: :string},
          mental_endurance: {type: :string}
        }
      }

      let!(:existing_cosmonaut) { create :cosmonaut }
      let(:id) { existing_cosmonaut.id }
      let(:cosmonaut) { attributes_for :cosmonaut }

      response "200", :success do
        schema type: :object, properties: {
          data: {"$ref" => "#/components/schemas/cosmonaut"}
        }

        run_test!

        it "matches snapshot", generate_swagger_example: true do
          expect(response.body).to match_snapshot("api/v1/update-cosmonaut")
          expect(response_json["data"]["attributes"].symbolize_keys).to eq(cosmonaut)
        end
      end

      response "422", :unprocessable_entity do
        let(:cosmonaut) { attributes_for :cosmonaut, first_name: nil }

        schema type: :object, properties: {
          errors: {type: :object, properties: {first_name: {type: :array, items: {type: :string}}}}
        }

        run_test!

        it "return correct error message" do
          expect(response_json["errors"]["first_name"]).to eq(["can't be blank"])
        end
      end

      response "404", :not_found do
        let(:id) { 0 }

        schema type: :object, properties: {errors: {type: :string}}

        run_test!
      end
    end

    delete "Deletes appropriate cosmonaut" do
      tags "Cosmonauts"
      consumes "application/json"
      produces "application/json"
      parameter name: :id, in: :path, type: :string, description: "Cosmonaut ID"

      let!(:cosmonaut) { create :cosmonaut }
      let(:id) { cosmonaut.id }

      response "204", :no_content do
        run_test!
      end

      response "404", :not_found do
        let(:id) { 0 }

        schema type: :object, properties: {errors: {type: :string}}

        run_test!
      end
    end
  end
end