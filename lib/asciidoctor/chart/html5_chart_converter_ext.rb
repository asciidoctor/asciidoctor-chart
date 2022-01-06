# frozen_string_literal: true

module Asciidoctor
  module Chart
    module Html5ChartConverterExt
      def convert_chart node
        chart_engine = node.attr 'engine'
        chart_type = node.attr 'type'
        chart_converter = Asciidoctor::Chart::Registry.for chart_engine

        if chart_converter
          if chart_converter.handles? chart_type
            chart_converter.send "convert_#{chart_type}_chart", node
          else
            logger.warn %(missing chart convert handler for type '#{chart_type}' in #{chart_converter})
            nil
          end
        else
          logger.warn %(missing chart convert for engine '#{chart_engine}')
          nil
        end
      end
    end
  end
end
