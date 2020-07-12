# frozen_string_literal: true

module Asciidoctor
  module Chart
    class BlockMacroProcessor < ::Asciidoctor::Extensions::BlockMacroProcessor
      use_dsl
      named :chart
      name_positional_attributes 'type', 'width', 'height', 'axis-x-label', 'axis-y-label', 'data-names'

      def process parent, target, attrs
        data_path = parent.normalize_asset_path target, 'target'
        read_data = parent.read_asset data_path, warn_on_failure: true, normalize: true
        unless read_data.nil? || read_data.empty?
          engine = Backend.resolve_engine attrs, parent.document
          raw_data = PlainRubyCSV.parse read_data
          html = Backend.process engine, attrs, raw_data
          create_pass_block parent, html, attrs, subs: nil
        end
      end
    end
  end
end
