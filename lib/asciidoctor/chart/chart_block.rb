# frozen_string_literal: true

module Asciidoctor
  module Chart
    class ChartBlock < Asciidoctor::Block
      def initialize(parent, data, attrs)
        engine = parent.document.get_engine attrs
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

    module ChartBlockTracker
      attr_reader :x_chart

      def self.extended instance
        instance.instance_variable_set :@x_chart, {
          engines: Set.new
        }
      end

      def get_engine attrs
        engine = if attrs.key? 'engine'
                   attrs['engine'].downcase
                 elsif @attributes.key? 'chart-engine'
                   @attributes['chart-engine'].downcase
                 else
                   'c3js'
                 end
        @x_chart[:engines].add(engine)

        engine
      end
    end
  end
end
