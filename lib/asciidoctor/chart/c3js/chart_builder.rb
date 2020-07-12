# frozen_string_literal: true

module Asciidoctor
  module Chart
    module C3js
      class ChartBuilder
        def self.bar data, labels, attrs
          chart_id = get_chart_id
          chart_div = create_chart_div chart_id
          chart_generate_script = chart_bar_script chart_id, data, labels, attrs
          to_html chart_div, chart_generate_script
        end

        def self.line data, labels, attrs
          chart_id = get_chart_id
          chart_div = create_chart_div chart_id
          chart_generate_script = chart_line_script chart_id, data, labels, attrs
          to_html chart_div, chart_generate_script
        end

        def self.step data, labels, attrs
          chart_id = get_chart_id
          chart_div = create_chart_div chart_id
          chart_generate_script = chart_step_script chart_id, data, labels, attrs
          to_html chart_div, chart_generate_script
        end

        def self.spline data, labels, attrs
          chart_id = get_chart_id
          chart_div = create_chart_div chart_id
          chart_generate_script = chart_spline_script chart_id, data, labels, attrs
          to_html chart_div, chart_generate_script
        end

        def self.create_chart_div chart_id
          %(<div id="#{chart_id}"></div>)
        end

        def self.get_chart_id
          # TODO Read from attributes ?
          'chart' + PlainRubyRandom.uuid
        end

        def self.prepare_data raw_data
          labels = raw_data[0]
          raw_data.shift
          raw_data.map.with_index {|row, index| row.unshift %(#{index}) }
          return raw_data, labels
        end

        def self.chart_bar_script chart_id, data, labels, attrs
          chart_height = get_chart_height attrs
          chart_width = get_chart_width attrs
          <<~EOS
          <script type="text/javascript">
          c3.generate({
            bindto: '##{chart_id}',
            size: { height: #{chart_height}, width: #{chart_width} },
            data: {
              columns: #{data.to_s},
              type: 'bar'
            },
            axis: {
              x: {
                type: 'category',
                categories: #{labels.to_s}
              }
            }
          });
          </script>
          EOS
        end

        def self.chart_line_script chart_id, data, labels, attrs
          chart_height = get_chart_height attrs
          chart_width = get_chart_width attrs
          <<~EOS
          <script type="text/javascript">
          c3.generate({
            bindto: '##{chart_id}',
            size: { height: #{chart_height}, width: #{chart_width} },
            data: {
              columns: #{data.to_s}
            },
            axis: {
              x: {
                type: 'category',
                categories: #{labels.to_s}
              }
            }
          });
          </script>
          EOS
        end

        def self.chart_step_script chart_id, data, labels, attrs
          chart_height = get_chart_height attrs
          chart_width = get_chart_width attrs
          <<~EOS
          <script type="text/javascript">
          c3.generate({
            bindto: '##{chart_id}',
            size: { height: #{chart_height}, width: #{chart_width} },
            data: {
              columns: #{data.to_s},
              type: 'step'
            },
            axis: {
              x: {
                type: 'category',
                categories: #{labels.to_s}
              }
            }
          });
          </script>
          EOS
        end

        def self.chart_spline_script chart_id, data, labels, attrs
          chart_height = get_chart_height attrs
          chart_width = get_chart_width attrs
          <<~EOS
          <script type="text/javascript">
          c3.generate({
            bindto: '##{chart_id}',
            size: { height: #{chart_height}, width: #{chart_width} },
            data: {
              columns: #{data.to_s},
              type: 'spline'
            },
            axis: {
              x: {
                type: 'category',
                categories: #{labels.to_s}
              }
            }
          });
          </script>
          EOS
        end

        def self.to_html chart_div, chart_script
          <<~EOS
          #{chart_div}
          #{chart_script}
          EOS
        end

        def self.get_chart_height attrs
          (attrs.key? 'height') ? attrs['height'] : '400'
        end

        def self.get_chart_width attrs
          (attrs.key? 'width') ? attrs['width'] : '600'
        end
      end
    end
  end
end
