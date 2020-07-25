# frozen_string_literal: true

module Asciidoctor
  module Chart
    module C3js
      class ChartBuilder
        def self.bar data, labels, attrs
          chart_id = get_chart_id attrs
          chart_div = create_chart_div chart_id
          chart_generate_script = chart_bar_script chart_id, data, labels, attrs
          to_html chart_div, chart_generate_script
        end

        def self.line data, labels, attrs
          chart_id = get_chart_id attrs
          chart_div = create_chart_div chart_id
          chart_generate_script = chart_line_script chart_id, data, labels, attrs
          to_html chart_div, chart_generate_script
        end

        def self.step data, labels, attrs
          chart_id = get_chart_id attrs
          chart_div = create_chart_div chart_id
          chart_generate_script = chart_step_script chart_id, data, labels, attrs
          to_html chart_div, chart_generate_script
        end

        def self.spline data, labels, attrs
          chart_id = get_chart_id attrs
          chart_div = create_chart_div chart_id
          chart_generate_script = chart_spline_script chart_id, data, labels, attrs
          to_html chart_div, chart_generate_script
        end

        def self.pie raw_data, attrs
          chart_id = get_chart_id attrs
          chart_div = create_chart_div chart_id
          chart_generate_script = chart_pie_script chart_id, raw_data, attrs
          to_html chart_div, chart_generate_script
        end

        def self.create_chart_div chart_id
          %(<div id="#{chart_id}"></div>)
        end

        def self.get_chart_id attrs
          attrs.fetch('id', 'chart' + PlainRubyRandom.uuid)
        end

        def self.prepare_data raw_data
          labels = raw_data[0]
          raw_data.shift
          raw_data.map.with_index {|row, index| row.unshift index.to_s }
          [raw_data, labels]
        end

        def self.chart_bar_script chart_id, data, labels, attrs
          chart_height = get_chart_height attrs
          chart_width = get_chart_width attrs
          axis_x_label = get_axis_x_label attrs
          axis_y_label = get_axis_y_label attrs
          data_names = get_data_names attrs
          <<~EOS
          <script>
          c3.generate({
            bindto: '##{chart_id}',
            size: { height: #{chart_height}, width: #{chart_width} },
            data: {
              columns: #{data.to_s},
              type: 'bar',
              names: #{data_names.to_s}
            },
            axis: {
              x: {
                type: 'category',
                categories: #{labels.to_s},
                label: '#{axis_x_label}'
              },
              y: {
                label: '#{axis_y_label}'
              }
            }
          });
          </script>
          EOS
        end

        def self.chart_line_script chart_id, data, labels, attrs
          chart_height = get_chart_height attrs
          chart_width = get_chart_width attrs
          axis_x_label = get_axis_x_label attrs
          axis_y_label = get_axis_y_label attrs
          data_names = get_data_names attrs
          <<~EOS
          <script>
          c3.generate({
            bindto: '##{chart_id}',
            size: { height: #{chart_height}, width: #{chart_width} },
            data: {
              columns: #{data.to_s},
              names: #{data_names.to_s}
            },
            axis: {
              x: {
                type: 'category',
                categories: #{labels.to_s},
                label: '#{axis_x_label}'
              },
              y: {
                label: '#{axis_y_label}'
              }
            }
          });
          </script>
          EOS
        end

        def self.chart_step_script chart_id, data, labels, attrs
          chart_height = get_chart_height attrs
          chart_width = get_chart_width attrs
          axis_x_label = get_axis_x_label attrs
          axis_y_label = get_axis_y_label attrs
          data_names = get_data_names attrs
          <<~EOS
          <script>
          c3.generate({
            bindto: '##{chart_id}',
            size: { height: #{chart_height}, width: #{chart_width} },
            data: {
              columns: #{data.to_s},
              type: 'step',
              names: #{data_names.to_s}
            },
            axis: {
              x: {
                type: 'category',
                categories: #{labels.to_s},
                label: '#{axis_x_label}'
              },
              y: {
                label: '#{axis_y_label}'
              }
            }
          });
          </script>
          EOS
        end

        def self.chart_spline_script chart_id, data, labels, attrs
          chart_height = get_chart_height attrs
          chart_width = get_chart_width attrs
          axis_x_label = get_axis_x_label attrs
          axis_y_label = get_axis_y_label attrs
          data_names = get_data_names attrs
          <<~EOS
          <script>
          c3.generate({
            bindto: '##{chart_id}',
            size: { height: #{chart_height}, width: #{chart_width} },
            data: {
              columns: #{data.to_s},
              type: 'spline',
              names: #{data_names.to_s}
            },
            axis: {
              x: {
                type: 'category',
                categories: #{labels.to_s},
                label: '#{axis_x_label}'
              },
              y: {
                label: '#{axis_y_label}'
              }
            }
          });
          </script>
          EOS
        end

        def self.chart_pie_script chart_id, raw_data, attrs
          chart_height = get_chart_height attrs
          chart_width = get_chart_width attrs
          <<~EOS
					<script>
					c3.generate({
						bindto: '##{chart_id}',
						size: { height: #{chart_height}, width: #{chart_width} },
						data: {
							columns: #{raw_data.to_s},
							type: 'pie'
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
          attrs.fetch 'height', '400'
        end

        def self.get_chart_width attrs
          attrs.fetch 'width', '600'
        end

        def self.get_axis_x_label attrs
          attrs.key?('axis-x-label') ? CGI.unescapeHTML(attrs['axis-x-label']) : ''
        end

        def self.get_axis_y_label attrs
          attrs.key?('axis-y-label') ? CGI.unescapeHTML(attrs['axis-y-label']) : ''
        end

        def self.get_data_names attrs
          attrs.key?('data-names') ? CGI.unescapeHTML(attrs['data-names']) : '{}'
        end
      end
    end
  end
end
