module Tatev
  module API
    module Routes
      class Processors < Grape::API
        version 'v1'
        
        resource :processors do
          params do
            requires :address, type: String
            optional :rules, type: Array, default: [] do
              requires :id, type: String
              requires :name, type: String
              requires :version, type: String
            end
          end

          post do
            args = declared(params)
            if !Processor.first(address: args.address)
              pr = Processor.create(address: args.address)
              pr.update_rules(args.rules)
              pr.save

              { status: :ok }
            else
              status 400
              { status: :rule_exists }
            end
          end

          route_param :id do
            params do
              requires :id, type: Integer
              # why should I repeat this?
              requires :address, type: String
              optional :rules, type: Array, default: [] do
                requires :id, type: String
                requires :name, type: String
                requires :version, type: String
              end
            end
            
            put do
              args = declared(params)
              pr = Processor.first(id: args.id)
              if pr
                pr.update(address: args.address)
                pr.update_rules(args.rules)

                { status: :ok }
              else
                status :not_found

                { status: :no_such_processor }
              end
            end
          end
        end
      end
    end
  end
end
