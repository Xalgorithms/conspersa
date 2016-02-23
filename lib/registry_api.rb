require_relative './service_api'

module Tatev
  class RegistryAPI < ServiceAPI
    def update(id, content)
      post("/v1/contexts/#{id}", content: content) do |body|
        logger.info(body)
      end
    end
  end
end
