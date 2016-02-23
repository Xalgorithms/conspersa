namespace :workers do
  require 'queue'

  desc 'listen'
  task :listen, [] => :environment do |t, args|
    q = Tatev::Worker.new
    q.up
    q.subscribe do |o|
      p o
    end
    q.down
  end
end
