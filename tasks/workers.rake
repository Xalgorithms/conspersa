namespace :workers do
  require 'queue'
  require 'repository'
  require 'processor_api'

  def api_for(address)
    @apis ||= {
    }
    if !@apis.key?(address)
      @apis[address] = Tatev::ProcessorAPI.new(address)
    end
    yield(@apis[address])
  end
  
  desc 'listen'
  task :listen, [] => :environment do |t, args|
    q = Tatev::Worker.new
    q.up
    q.subscribe do |o|
      Context.with(public_id: o['context_id']) do |cm|
        cr = cm.current_rule
        nr = cm.next_rule

        if cr
          cm.update(status: 'processing', current_rule: nr)
          
          repo = Tatev::Repository.new(cm.invocation.client_id)
          repo.get(cm.invocation.public_id, cm.public_id) do |content|
            api_for(cr.processor.address) do |api|
              api.invoke(cr.source_id, cr.version, cm.public_id, content)
            end
          end
        else
          cm.update(status: 'finished', current_rule: nil)
        end
      end
    end
    
    q.down
  end
end
