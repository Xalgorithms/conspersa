require 'bunny'
require 'multi_json'

module Tatev
  class Base
    def initialize
    end

    def up
      user = ENV.fetch('RABBITMQ_USER', 'admin')
      pass = ENV.fetch('RABBITMQ_PASS', nil)
      host = ENV.fetch('RABBITMQ_HOST', 'mq')

      @conn = Bunny.new(user: user, pass: pass, hostname: host)
      @conn.start
      @channel = @conn.create_channel
      @queue = @channel.queue('invocations')
    end

    def down
      @channel.close if @channel
      @conn.close if @conn
    end

    protected

    def queue
      @queue
    end

    def channel
      @channel
    end
  end
  
  class Queue < Base
    def self.publish(o)
      q = Queue.new
      q.up
      q.publish(o)
      q.down
    end
    
    def publish(o)
      channel.default_exchange.publish(MultiJson.encode(o), routing_key: queue.name)
    end
  end

  class Worker < Base
    def subscribe(&bl)
      queue.subscribe(block: true) do |di, props, body|
        o = MultiJson.decode(body)
        bl.call(o) if bl && o
      end
    end
  end
end
