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

      private

      def cosmonaut_params
        params.required(:cosmonaut).permit(:first_name, :last_name, :physical_condition, :mental_endurance)
      end
    end
  end
end
