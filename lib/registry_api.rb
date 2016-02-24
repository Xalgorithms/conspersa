require_relative './service_api'

module Tatev
  class RegistryAPI < ServiceAPI
    def update(id, content)
      post("/v1/contexts/#{id}", content: content) do |body|
        logger.info(body)
      end
    end

    def register(url, rules)
      get("/v1/processors") do |processors|
        us = processors.find { |pr| url == pr['address'] }
        content = { address: url, rules: rules }
        if !us
          logger.info('# POST new processor')
          post("/v1/processors", content) do |body|
            logger.info(body)
          end
        else
          logger.info('# PUT existing processor')
          put("/v1/processors/#{us['id']}", content) do |body|
            logger.info(body)
          end
        end
      end
    end
  end
end
