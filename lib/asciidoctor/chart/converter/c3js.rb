# frozen_string_literal: true

module Asciidoctor
  module Chart
    module Converter
      class Html5C3jsConverter < Asciidoctor::Chart::Converter::Base
        def convert_line_chart node
          data, labels = prepare_data node
          chart_generate_script = chart_line_script node, data, labels
          <<~HTML
            #{chart_block_element node}
            #{chart_generate_script}
          HTML
        end

        def convert_bar_chart node
          data, labels = prepare_data node
          <<~HTML
            #{chart_block_element node}
            #{chart_bar_script node, data, labels}
          HTML
        end

        def convert_step_chart node
          data, labels = prepare_data node
          <<~HTML
            #{chart_block_element node}
            #{chart_step_script node, data, labels}
          HTML
        end

        def convert_spline_chart node
          data, labels = prepare_data node
          <<~HTML
            #{chart_block_element node}
            #{chart_spline_script node, data, labels}
          HTML
        end

        def convert_pie_chart node
          raw_data = node.attr 'data-raw', []
          <<~HTML
            #{chart_block_element node}
            #{chart_pie_script node, raw_data}
          HTML
        end

        private

        def prepare_data node
          raw_data = node.attr 'data-raw', []
          return [[], []] if raw_data.length <= 1 # question: should we warn?

          labels = raw_data[0]
          raw_data.shift
          raw_data.map.with_index {|row, index| row.unshift index.to_s }
          [raw_data, labels]
        end

        def chart_bar_script node, data, labels
          chart_height = get_chart_height node
          chart_width = get_chart_width node
          axis_x_label = get_axis_x_label node
          axis_y_label = get_axis_y_label node
          data_names = get_data_names node
          <<~HTML
            <script>
              c3.generate({
                bindto: '##{node.attr 'id'}',
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
              })
            </script>
          HTML
        end

        def chart_line_script node, data, labels
          chart_height = get_chart_height node
          chart_width = get_chart_width node
          axis_x_label = get_axis_x_label node
          axis_y_label = get_axis_y_label node
          data_names = get_data_names node
          <<~HTML
            <script>
              c3.generate({
                bindto: '##{node.attr 'id'}',
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
              })
            </script>
          HTML
        end

        def chart_step_script node, data, labels
          chart_height = get_chart_height node
          chart_width = get_chart_width node
          axis_x_label = get_axis_x_label node
          axis_y_label = get_axis_y_label node
          data_names = get_data_names node
          <<~HTML
            <script>
              c3.generate({
                bindto: '##{node.attr 'id'}',
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
              })
            </script>
          HTML
        end

        def chart_spline_script node, data, labels
          chart_height = get_chart_height node
          chart_width = get_chart_width node
          axis_x_label = get_axis_x_label node
          axis_y_label = get_axis_y_label node
          data_names = get_data_names node
          <<~HTML
            <script>
              c3.generate({
                bindto: '##{node.attr 'id'}',
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
              })
            </script>
          HTML
        end

        def chart_pie_script node, raw_data
          chart_height = get_chart_height node
          chart_width = get_chart_width node
          <<~HTML
            <script>
              c3.generate({
                bindto: '##{node.attr 'id'}',
                size: { height: #{chart_height}, width: #{chart_width} },
                data: {
                  columns: #{raw_data.to_s},
                  type: 'pie'
                }
              })
            </script>
          HTML
        end

        def chart_block_element node
          title_element = node.title? ? %(\n  <div class="title">#{node.captioned_title}</div>) : ''
          %(<div class="chartblock">
  <div class="content c3js-content">
    <div id="#{node.attr 'id'}"></div>
  </div>#{title_element}
</div>)
        end

        def get_chart_height node
          node.attr 'height', '400'
        end

        def get_chart_width node
          node.attr 'width', '600'
        end

        def get_axis_x_label node
          node.attr?('axis-x-label') ? CGI.unescapeHTML(node.attr('axis-x-label')) : ''
        end

        def get_axis_y_label node
          node.attr?('axis-y-label') ? CGI.unescapeHTML(node.attr('axis-y-label')) : ''
        end

        def get_data_names node
          node.attr?('data-names') ? CGI.unescapeHTML(node.attr('data-names')) : '{}'
        end
      end
    end
  end
end
