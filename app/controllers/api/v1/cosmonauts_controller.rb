module API
  module V1
    class CosmonautsController < ApplicationController
      def index
        cosmonauts = Cosmonaut.all
        cosmonauts = cosmonauts.limit(params[:limit]) if params[:limit].present?
        render json: CosmonautSerializer.new(cosmonauts).serializable_hash
      end

      def show
        cosmonaut = Cosmonaut.find(params[:id])
        render json: CosmonautSerializer.new(cosmonaut).serializable_hash
      end

      def create
        cosmonaut = Cosmonaut.new(cosmonaut_params)
        if cosmonaut.save
          render json: CosmonautSerializer.new(cosmonaut).serializable_hash
        else
          render json: {errors: cosmonaut.errors}, status: :unprocessable_entity
        end
      end

      def update
        cosmonaut = Cosmonaut.find(params[:id])
        if cosmonaut.update(cosmonaut_params)
          render json: CosmonautSerializer.new(cosmonaut).serializable_hash
        else
          render json: {errors: cosmonaut.errors}, status: :unprocessable_entity
        end
      end

      def destroy
        cosmonaut = Cosmonaut.find(params[:id])
        if cosmonaut.destroy
          render json: {}, status: :no_content
        else
          render json: {errors: cosmonaut.errors}, status: :unprocessable_entity
        end
      end

      def import
        tempfile = (params[:file] || params[:cosmonauts][:file]).tempfile # maybe it would be more memory efficient to use request.env['rack.input'] stream directly instead of tempfile
        records = []
        Nokogiri::XML::Reader(tempfile).each do |node|
          if node.name == 'cosmonaut' && node.node_type == Nokogiri::XML::Reader::TYPE_ELEMENT
            inner_xml = Nokogiri::XML(node.outer_xml).at('./cosmonaut')
            records << {
              id: inner_xml.at("./id").content,
              first_name: inner_xml.at("./first_name").content,
              last_name: inner_xml.at("./last_name").content,
              physical_condition: inner_xml.at("./physical_condition").content,
              mental_endurance: inner_xml.at("./mental_endurance").content
            }
            if records.size >= 500 # save every 500 records
              Cosmonaut.upsert_all records, unique_by: :id
              records = []
            end
          end
        end
        Cosmonaut.upsert_all records, unique_by: :id

        render json: {}, status: :ok
      end

      def export
        response.headers['Content-Type'] = 'application/xml'
        response.headers['Content-Disposition'] = 'attachment; filename=cosmonauts.xml'

        self.response_body = Enumerator.new do |yielder|
          yielder << '<?xml version="1.0" encoding="UTF-8"?>'
          yielder << '<cosmonauts>'
          Cosmonaut.find_each(batch_size: 500) do |cosmonaut|
            yielder << '<cosmonaut>'
            yielder << "<id>#{cosmonaut.id}</id>"
            yielder << "<first_name>#{cosmonaut.first_name}</first_name>"
            yielder << "<last_name>#{cosmonaut.last_name}</last_name>"
            yielder << "<physical_condition>#{cosmonaut.physical_condition}</physical_condition>"
            yielder << "<mental_endurance>#{cosmonaut.mental_endurance}</mental_endurance>"
            yielder << '</cosmonaut>'
          end
          yielder << '</cosmonauts>'
        end
      end

      private

      def cosmonaut_params
        params.required(:cosmonaut).permit(:first_name, :last_name, :physical_condition, :mental_endurance)
      end
    end
  end
end
