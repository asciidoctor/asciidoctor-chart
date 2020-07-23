# frozen_string_literal: true

require 'asciidoctor'
require_relative '../lib/asciidoctor-chart'

describe 'Asciidoctor::Chart::BlockProcessor' do
  it 'should do something' do
    input = <<~'ADOC'
      [chart#month-stats,line]
      ....
      January,February,March,April,May,June,July
      28,48,40,19,86,27,90
      65,59,80,81,56,55,40
      ....
    ADOC
    output = Asciidoctor.convert(input, standalone: false)
    (expect output).to eql %(<div id="month-stats"></div>
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
});
</script>)
  end
end
