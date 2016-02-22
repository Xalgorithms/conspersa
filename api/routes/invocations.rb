module Tatev
  module API
    module Routes
      class Invocations < Grape::API
        version 'v1'

        helpers do
          def logger
            Invocations.logger
          end
        end
        
        resource :invocations do
          params do
            requires :client, type: Hash do
              requires :id, type: String
            end
            requires :contexts, type: Array do
              requires :content, type: Hash
              requires :rules, type: Array do
                requires :id, type: String
                requires :version, type: String
              end
            end
          end
          
          post do
            args = declared(params)
            repo = Repository.new(Padrino.root('repos', args.client.id))
            invocation_id = UUID.generate
            
            statuses = args.contexts.map do |context|
              context_id = UUID.generate
              repo.add(invocation_id, context_id, context.content.to_json)
              { id: context_id, status: :started }
            end

            { invocation: { id: invocation_id }, contexts: statuses }
          end
        end

        resource :invocations do
          route_param :id do
            get do
            end
          end
        end
      end
    end
  end
end
