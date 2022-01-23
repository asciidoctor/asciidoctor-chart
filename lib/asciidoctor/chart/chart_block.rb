# frozen_string_literal: true

module Asciidoctor
  module Chart
    class ChartBlock < Asciidoctor::Block
      def initialize(parent, data, attrs)
        parent_document = parent.document
        engine = if attrs.key? 'engine'
                   attrs['engine'].downcase
                 elsif parent_document.attributes.key? 'chart-engine'
                   parent_document.attributes['chart-engine'].downcase
                 else
                   'c3js'
                 end
        caption = attrs.delete 'caption'
        title = attrs.delete 'title'
        block_attributes = attrs.merge({
                                         'id' => attrs['id'] || "chart#{PlainRubyRandom.uuid}",
                                         'type' => attrs['type'] || 'line',
                                         'engine' => engine,
                                         'data-raw' => data
                                       })
        super parent, :chart, { source: nil, attributes: block_attributes, subs: nil }
        @title = title
        assign_caption(caption, 'figure')
      end
    end
  end
end
