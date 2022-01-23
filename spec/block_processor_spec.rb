# frozen_string_literal: true

require 'asciidoctor'
require_relative '../lib/asciidoctor-chart'

describe 'Asciidoctor::Chart::BlockProcessor' do
  it 'should convert a chart using the default engine (c3js)' do
    input = <<~'ADOC'
      [chart#month-stats,line]
      ....
      January,February,March,April,May,June,July
      28,48,40,19,86,27,90
      65,59,80,81,56,55,40
      ....
    ADOC
    output = Asciidoctor.convert(input, standalone: false)
    (expect output.strip).to eql %(<div class="chartblock">
  <div class="content c3js-content">
    <div id="month-stats"></div>
  </div>
</div>
<script>
  c3.generate({
    bindto: '#month-stats',
    size: { height: 400, width: 600 },
    data: {
      columns: [["0", "28", "48", "40", "19", "86", "27", "90"], ["1", "65", "59", "80", "81", "56", "55", "40"]],
      names: {}
    },
    axis: {
      x: {
        type: 'category',
        categories: ["January", "February", "March", "April", "May", "June", "July"],
        label: ''
      },
      y: {
        label: ''
      }
    }
  })
</script>)
  end
  it 'should convert a chart with a title' do
    input = <<~'ADOC'
      .Sales
      [chart#sales]
      ....
      January,February,March,April,May,June,July
      28,48,40,19,86,27,90
      65,59,80,81,56,55,40
      ....
    ADOC
    output = Asciidoctor.convert(input, standalone: false)
    (expect output.strip).to eql %(<div class="chartblock">
  <div class="content c3js-content">
    <div id="sales"></div>
  </div>
  <div class="title">Figure 1. Sales</div>
</div>
<script>
  c3.generate({
    bindto: '#sales',
    size: { height: 400, width: 600 },
    data: {
      columns: [["0", "28", "48", "40", "19", "86", "27", "90"], ["1", "65", "59", "80", "81", "56", "55", "40"]],
      names: {}
    },
    axis: {
      x: {
        type: 'category',
        categories: ["January", "February", "March", "April", "May", "June", "July"],
        label: ''
      },
      y: {
        label: ''
      }
    }
  })
</script>)
  end
end
