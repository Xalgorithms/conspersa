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
              requires :address, type: String
              optional :rules, type: Array, default: [] do
                requires :id, type: String
                requires :name, type: String
                requires :version, type: String
              end
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
