# frozen_string_literal: true

module Asciidoctor
  module Chart
    module Converter
      class Html5ChartistConverter < Asciidoctor::Chart::Converter::Base
        def convert_line_chart node
          data, labels = prepare_data node
          <<~HTML
            #{chart_block_element node}
            #{chart_line_script node, data, labels}
          HTML
        end

        def convert_bar_chart node
          data, labels = prepare_data node
          <<~HTML
            #{chart_block_element node}
            #{chart_bar_script node, data, labels}
          HTML
        end

        private

        def prepare_data node
          raw_data = node.attr 'data-raw', []
          return [[], []] if raw_data.length <= 1 # question: should we warn?

          labels = raw_data[0]
          raw_data.shift
          [raw_data, labels]
        end

        def chart_block_element node
          title_element = node.title? ? %(\n  <div class="title">#{node.captioned_title}</div>) : ''
          %(<div class="chartblock">
  <div class="content chartist-content">
    <div id="#{node.attr 'id'}" class="ct-chart"></div>
  </div>#{title_element}
</div>)
        end

        def chart_line_script node, data, labels
          chart_height = node.attr 'height', '400'
          chart_width = node.attr 'width', '600'
          <<~HTML
            <script>
              var options = {
                height: '#{chart_height}',
                width: '#{chart_width}',
                colors: ["#72B3CC", "#8EB33B"]
              }
              var data = {
                labels: #{labels.to_s},
                series: #{data.to_s}
              }
              new Chartist.Line('##{node.attr 'id'}', data, options)
            </script>
          HTML
        end

        def chart_bar_script node, data, labels
          chart_height = node.attr 'height', '400'
          <<~HTML
            <script>
              var options = {
                height: '#{chart_height}',
                colors: ["#72B3CC", "#8EB33B"]
              }
              var data = {
                labels: #{labels.to_s},
                series: #{data.to_s}
              }
              new Chartist.Bar('##{node.attr 'id'}', data, options)
            </script>
          HTML
        end
      end
    end
  end
end
