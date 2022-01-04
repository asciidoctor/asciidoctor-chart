# frozen_string_literal: true

module Asciidoctor
  module Chart
    module Chartjs
      class ChartBuilder
        def self.line data, labels, attrs
          default_colors = [{ r: 220, g: 220, b: 220 }, { r: 151, g: 187, b: 205 }]
          datasets = data.map do |set|
            color = default_colors[data.index(set) % 2]
            color_rgba = "rgba(#{color[:r]},#{color[:g]},#{color[:b]},1.0)"
            <<~EOS
            {
              fillColor: "#{color_rgba.gsub('1.0', '0.2')}",
              strokeColor: "#{color_rgba}",
              pointColor: "#{color_rgba}",
              pointHighlightStroke: "#{color_rgba}",
              pointStrokeColor: "#fff",
              pointHighlightFill: "#fff",
              data: #{set.to_s}
            }
            EOS
          end.join ','
          chart_id = attrs.fetch('id', 'chart' + PlainRubyRandom.uuid)
          chart_height = get_chart_height attrs
          chart_width = get_chart_width attrs
          chart_canvas = %(<div style="width:#{chart_width}px; height:#{chart_height}px"><canvas id="#{chart_id}"></canvas></div>) # rubocop:disable Layout/LineLength
          chart_init_ctx_script = %(var ctx = document.getElementById("#{chart_id}").getContext("2d");)
          chart_init_data_script = <<~EOS
          var data = {
            labels: #{labels.to_s},
            datasets: [
              #{datasets}
            ]
          };
          EOS
          chart_init_script = 'var chart = new Chart(ctx).Line(data, {responsive : true});'
          <<~EOS
          #{chart_canvas}
          <script>
          window.addEventListener('load', function(event) {
          #{chart_init_ctx_script}
          #{chart_init_data_script}
          #{chart_init_script}
          })
          </script>
          EOS
        end

        def self.prepare_data raw_data
          labels = raw_data[0]
          raw_data.shift
          [raw_data, labels]
        end

        def self.get_chart_height attrs
          attrs.fetch 'height', '400'
        end

        def self.get_chart_width attrs
          attrs.fetch 'width', '600'
        end
      end
    end
  end
end
