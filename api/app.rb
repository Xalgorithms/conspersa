module Tatev
  module API
    class App < Grape::API
      class << self
        def cascade
          []
        end

        def root
          @_root ||= File.expand_path('..', __FILE__)
        end

        def dependencies
          @_dependencies ||= Dir[File.expand_path('../../api/routes/*.rb', __FILE__)]
        end

        def load_paths
          @_load_paths ||= [File.expand_path('../../api', __FILE__)]
        end

        ## NOTE: Taken from Padrino. Deprecated in master (0.13.0.rc1).
        ## Padrino apps must now modify $LOAD_PATH for themselves.
        ## See: https://github.com/padrino/padrino-framework/pull/1693
        ##
        # Concat to +$LOAD_PATH+ the given paths.
        #
        # @param [Array<String>] paths
        #   The paths to concat.
        #
        def set_load_paths(*paths)
          $LOAD_PATH.concat(paths).uniq!
        end

        def setup_application!
          @_configured ||= begin
                             set_load_paths(*load_paths)
                             Padrino.require_dependencies(dependencies, force: true)
                             Grape::API.logger = Padrino.logger
                             true
                           end
        end

        def register
          mode = ENV.fetch('TATEV_APP_MODE', 'registry')
          Padrino.logger.info("# booting application (mode=#{mode})")
          case mode
          when 'registry'
          when 'processor'
            Padrino.logger.info("# registering")
            api = Tatev::RegistryAPI.new(ENV.fetch('TATEV_REGISTRY_URL', 'http://localhost:8000'))
            # fix this hardcoded value
            api.register('http://localhost:9000', Tatev::Rules::NAMES.map do |n|
                           { id: n, name: n, version: 1 }
                         end)
          end
        end
        
        def app_file
          ''
        end

        def public_folder
          ''
        end
      end

      # booting
      setup_application!

      # move this later
      format :json
      use Grape::Middleware::Logger
      
      mount Tatev::API::Routes::Processors
      mount Tatev::API::Routes::Invocations

      register
    end
  end
end
