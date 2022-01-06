# frozen_string_literal: true

module Asciidoctor
  module Chart
    class BlockProcessor < ::Asciidoctor::Extensions::BlockProcessor
      use_dsl
      named :chart
      on_context :literal
      name_positional_attributes 'type', 'width', 'height', 'axis-x-label', 'axis-y-label', 'data-names'
      parse_content_as :raw

      def process parent, reader, attrs
        raw_data = PlainRubyCSV.parse reader.source
        Asciidoctor::Chart::ChartBlock.new parent, raw_data, attrs
      end
    end
  end
end
