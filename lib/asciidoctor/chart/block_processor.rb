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
        engine = Backend.resolve_engine attrs, parent.document
        raw_data = PlainRubyCSV.parse reader.source
        html = Backend.process engine, attrs, raw_data
        create_pass_block parent, html, attrs, subs: nil
      end
    end
  end
end
