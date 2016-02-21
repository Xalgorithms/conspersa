module Tatev
  module API
    module Routes
      class Processors < Grape::API
        get :hello do
          { hello: 'world' }
        end
      end
    end
  end
end
