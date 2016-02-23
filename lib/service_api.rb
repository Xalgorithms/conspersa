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

    def post(relative_url, args)
      resp = @conn.post(relative_url, args.merge(token: @token))
      if resp.success?
        yield(resp.body)
      else
        logger.error("Failed to post to #{relative_url}: #{resp.inspect}")
      end
    end

    def logger
      $stdout.sync = true
      @logger ||= Logger.new($stdout)
    end
  end
end
