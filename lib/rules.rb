module Tatev
  class Rules
    NAMES = [:convert_currency]

    def execute(id, version, content)
      Padrino.logger.info("# executing #{id} / #{version} content: #{content.inspect}")
      send(id, content)
    end

    private

    def convert_currency(content)
      @conversions ||= {
        'CAD' => {
          'USD' => lambda { |v| v * 1.4 },
        },
        'USD' => {
          'CAD' => lambda { |v| v / 1.4 },
        },
      }

      def_conversion = lambda { |v| v }
      fn = @conversions.fetch(content['from'], {}).fetch(content['to'], def_conversion)

      val = fn.call(content['value'].to_i)
      content.merge('value' => val.to_s)
    end
  end
end
