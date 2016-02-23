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
            im = Invocation.create(client_id: args.client.id, public_id: UUID.generate)
            repo = Repository.new(Padrino.root('repos', im.client_id))

            im.contexts = args.contexts.map do |context|
              cm = Context.create(public_id: UUID.generate, status: 'started')
              repo.add(im.public_id, cm.public_id, context.content.to_json)
              cm
            end

            im.save
            Tatev::Queue.publish(invocation_id: im.public_id)
            
            { invocation: { id: im.public_id }, contexts: im.contexts.map { |cm| { id: cm.public_id, status: cm.status.to_sym } } }
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
