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
              p cm
              repo.add(im.public_id, cm.public_id, MultiJson.encode(context.content))
              cm.rules = context.rules.map do |rule|
                Rule.first(source_id: rule.id, version: rule.version)
              end
              cm.current_rule = cm.rules.first
              cm.save
              
              cm
            end
            im.save

            Tatev::Queue.live do |q|
              im.contexts.each do |cm|
                q.publish(context_id: cm.public_id)
              end
            end
            
            { invocation: { id: im.public_id }, contexts: im.contexts.map { |cm| { id: cm.public_id, status: cm.status.to_sym } } }
          end
        end

        resource :invocations do
          route_param :id do
            get do
            end
          end
        end

        # temporary... this is not loading in another module... Also it really will get moved to the RP
        resource :rules do
          route_param :id do
            route_param :rule_version do
              resource :invocations do
                params do
                  requires :id, type: String
                  requires :rule_version, type: String
                  requires :content, type: Hash
                  requires :context_id, type: String
                end

                post do
                  args = declared(params)
                  logger.info("> #{args.id}/#{args.rule_version}")
                  logger.info(">> #{args.content.inspect}")

                  { status: :ok }
                end
              end
            end
          end
        end
      end
    end
  end
end
