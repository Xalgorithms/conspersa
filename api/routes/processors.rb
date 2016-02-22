module Tatev
  module API
    module Routes
      class Processors < Grape::API
        version 'v1'
        
        resource :processors do
          params do
            requires :id, type: Integer
          end
          route_param :id do
            params do
              optional :address
            end
            
            post do
              declared(params)
            end

            put do
            end
          end
        end
      end
    end
  end
end
