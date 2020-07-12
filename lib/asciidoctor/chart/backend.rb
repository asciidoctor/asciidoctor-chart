# frozen_string_literal: true

module Asciidoctor
  module Chart
    class Backend
      def self.resolve_engine attrs, document
        if attrs.key? 'engine'
          attrs['engine'].downcase
        elsif document.attributes.key? 'chart-engine'
          document.attributes['chart-engine'].downcase
        else
          'c3js'
        end
      end

      def self.process engine, attrs, raw_data
        # TODO Check that the engine can process the required type (bar, line, step...)
        type = attrs['type']
        case engine
        when 'c3js'
          data, labels = C3js::ChartBuilder.prepare_data raw_data
          case type
          when 'bar'
            C3js::ChartBuilder.bar data, labels, attrs
          when 'line'
            C3js::ChartBuilder.line data, labels, attrs
          when 'step'
            C3js::ChartBuilder.step data, labels, attrs
          when 'spline'
            C3js::ChartBuilder.spline data, labels, attrs
          else
            # By default chart line
            C3js::ChartBuilder.line data, labels, attrs
          end
        when 'chartist'
          data, labels = Chartist::ChartBuilder.prepare_data raw_data
          case type
          when 'bar'
            Chartist::ChartBuilder.bar data, labels, attrs
          when 'line'
            Chartist::ChartBuilder.line data, labels, attrs
          else
            # By default chart line
            Chartist::ChartBuilder.line data, labels, attrs
          end
        when 'chartjs'
          data, labels = Chartjs::ChartBuilder.prepare_data raw_data
          case type
          when 'line'
            Chartjs::ChartBuilder.line data, labels, attrs
          else
            # By default chart line
            Chartjs::ChartBuilder.line data, labels, attrs
          end
        end
      end
    end
  end
end
