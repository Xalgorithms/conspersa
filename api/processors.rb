module Tatev
  module API
    class Processors < Grape::API
      get :hello do
        { hello: 'world' }
      end
    end
  end
end
