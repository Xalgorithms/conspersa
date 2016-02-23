require_relative './service_api'

module Tatev
  class ProcessorAPI < ServiceAPI
    def invoke(id, version, context_id, content)
      post("/v1/rules/#{id}/#{version}/invocations", context_id: context_id, content: content) do |body|
        logger.info(body)
      end
    end
  end
end
