namespace :workers do
  require 'queue'
  require 'repository'

  desc 'listen'
  task :listen, [] => :environment do |t, args|
    q = Tatev::Worker.new
    q.up
    q.subscribe do |o|
      im = Invocation.first(public_id: o['invocation_id'])
      if im
        cm = im.contexts.first(status: 'started')
        if cm
          cm.status = 'waiting'
          cm.save
          
          repo = Tatev::Repository.new(Padrino.root('repos', im.client_id))
          content = repo.get(im.public_id, cm.public_id)
          p content
          Tatev::Queue.publish(invocation_id: im.public_id)          
        end
      end
    end
    q.down
  end
end
