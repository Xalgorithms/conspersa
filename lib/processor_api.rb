require 'faraday'
require 'faraday_middleware'

module Tatev
  class ProcessorAPI
    def initialize
      @conn = Faraday.new(ENV.fetch('PROCESSOR_URL')) do |f|
        f.request(:url_encoded)
        f.request(:json)
        f.response(:json, :content_type => /\bjson$/)
        f.adapter(Faraday.default_adapter)
      end
    end

    def invoke(id, version, content)
      post("/rules/#{:id}/#{:version}/invocations", content: content) do |body|
        logger.info(body)
      end
    end

    private

    def post(relative_url, args)
      resp = @conn.post(relative_url, args.merge(token: @token))
      if resp.status == 200
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
