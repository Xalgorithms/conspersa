require 'faraday'
require 'faraday_middleware'

module Tatev
  class ServiceAPI
    def initialize(url)
      @conn = Faraday.new(url) do |f|
        f.request(:url_encoded)
        f.request(:json)
        f.response(:json, :content_type => /\bjson$/)
        f.adapter(Faraday.default_adapter)
      end
    end

    protected

    def get(relative_url)
      resp = @conn.get(relative_url)
      if resp.success?
        yield(resp.body)
      else
        logger.error("failed to get #{relative_url}")
      end
    end
    
    def put(relative_url, args, &bl)
      send(:put, relative_url, args, &bl)
    end

    def post(relative_url, args)
      send(:post, relative_url, args)
    end
    
    def send(action, relative_url, args, &bl)
      resp = @conn.send(action, relative_url, args)
      if resp.success?
        bl.call(resp.body) if bl
      else
        logger.error("Failed to #{action} to #{relative_url}: #{resp.inspect}")
      end
    end

    def logger
      $stdout.sync = true
      @logger ||= Logger.new($stdout)
    end
  end
end
