# frozen_string_literal: true

require 'asciidoctor'
require_relative 'spec_helper'
require_relative '../lib/asciidoctor-chart'

describe 'Asciidoctor::Chart::DocinfoProcessor' do
  it 'should append only the required styles and scripts (C3.js)' do
    input = <<~'ADOC'
      [chart#month-stats,line]
      ....
      January,February,March,April,May,June,July
      28,48,40,19,86,27,90
      65,59,80,81,56,55,40
      ....
    ADOC
    output = Asciidoctor.convert(input, standalone: true)
    (expect output.strip).to include %(<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/c3/0.3.0/c3.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/d3/3.4.11/d3.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/c3/0.3.0/c3.min.js"></script>
<style>
  .chartblock {
    margin-bottom: 1.25em;
  }
  .chartblock > .title {
    text-rendering: optimizeLegibility;
    text-align: left;
    font-size: 1rem;
    font-style: italic;
    line-height: 1.45;
    color: #7a2518;
    font-weight: 400;
  }
  .chartblock > .chartjs-content {
    position: relative;
    margin-bottom: 0.25em;
  }
</style>)
    (expect output.strip).not_to include %(<script src="https://cdn.jsdelivr.net/chartist.js/)
    (expect output.strip).not_to include %(<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/)
  end
  it 'should append only the required styles and scripts (chartist.js)' do
    input = <<~'ADOC'
      :chart-engine: chartist

      [chart#month-stats,line]
      ....
      January,February,March,April,May,June,July
      28,48,40,19,86,27,90
      65,59,80,81,56,55,40
      ....
    ADOC
    output = Asciidoctor.convert(input, standalone: true)
    (expect output.strip).to include %(<link rel="stylesheet" href="https://cdn.jsdelivr.net/chartist.js/latest/chartist.min.css">
<script src="https://cdn.jsdelivr.net/chartist.js/latest/chartist.min.js"></script>
<style>
  .chartblock {
    margin-bottom: 1.25em;
  }
  .chartblock > .title {
    text-rendering: optimizeLegibility;
    text-align: left;
    font-size: 1rem;
    font-style: italic;
    line-height: 1.45;
    color: #7a2518;
    font-weight: 400;
  }
  .chartblock > .chartjs-content {
    position: relative;
    margin-bottom: 0.25em;
  }
</style>)
    (expect output.strip).not_to include %(<script src="https://cdnjs.cloudflare.com/ajax/libs/c3/)
    (expect output.strip).not_to include %(<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/)
  end
  it 'should append only the required styles and scripts (Chart.js)' do
    input = <<~'ADOC'
      :chart-engine: chartjs

      [chart#month-stats,line]
      ....
      January,February,March,April,May,June,July
      28,48,40,19,86,27,90
      65,59,80,81,56,55,40
      ....
    ADOC
    output = Asciidoctor.convert(input, standalone: true)
    (expect output.strip).to include %(<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.7.0/chart.min.js"></script>
<style>
  .chartblock {
    margin-bottom: 1.25em;
  }
  .chartblock > .title {
    text-rendering: optimizeLegibility;
    text-align: left;
    font-size: 1rem;
    font-style: italic;
    line-height: 1.45;
    color: #7a2518;
    font-weight: 400;
  }
  .chartblock > .chartjs-content {
    position: relative;
    margin-bottom: 0.25em;
  }
</style>)
    (expect output.strip).not_to include %(<script src="https://cdnjs.cloudflare.com/ajax/libs/d3/)
    (expect output.strip).not_to include %(<script src="https://cdnjs.cloudflare.com/ajax/libs/c3/)
    (expect output.strip).not_to include %(<script src="https://cdn.jsdelivr.net/chartist.js/)
  end
  it 'should append only the required styles and scripts (Chart.js + C3.js)' do
    input = <<~ADOC
      :chart-engine: chartjs

      [chart#month-stats,line]
      ....
      January,February,March,April,May,June,July
      28,48,40,19,86,27,90
      65,59,80,81,56,55,40
      ....

      chart::#{fixturedir}/sample-data.csv[line,engine=c3js]
    ADOC
    output = Asciidoctor.convert(input, standalone: true)
    (expect output.strip).to include %(<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.7.0/chart.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/c3/0.3.0/c3.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/d3/3.4.11/d3.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/c3/0.3.0/c3.min.js"></script>
<style>
  .chartblock {
    margin-bottom: 1.25em;
  }
  .chartblock > .title {
    text-rendering: optimizeLegibility;
    text-align: left;
    font-size: 1rem;
    font-style: italic;
    line-height: 1.45;
    color: #7a2518;
    font-weight: 400;
  }
  .chartblock > .chartjs-content {
    position: relative;
    margin-bottom: 0.25em;
  }
</style>)
    (expect output.strip).not_to include %(<script src="https://cdn.jsdelivr.net/chartist.js/)
  end
  it 'if c3jsdir is defined, should append the required styles and scripts relative based (C3.js)' do
    input = <<~ADOC
      :chart-engine: c3js
      :c3jsdir: ../c3

      [chart#month-stats,line]
      ....
      January,February,March,April,May,June,July
      28,48,40,19,86,27,90
      65,59,80,81,56,55,40
      ....

      chart::#{fixturedir}/sample-data.csv[line]
    ADOC
    output = Asciidoctor.convert(input, standalone: true)
    (expect output.strip).to include %(<link rel="stylesheet" href="../c3/c3.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/d3/3.4.11/d3.min.js"></script>
<script src="../c3/c3.min.js"></script>
<style>
  .chartblock {
    margin-bottom: 1.25em;
  }
  .chartblock > .title {
    text-rendering: optimizeLegibility;
    text-align: left;
    font-size: 1rem;
    font-style: italic;
    line-height: 1.45;
    color: #7a2518;
    font-weight: 400;
  }
  .chartblock > .chartjs-content {
    position: relative;
    margin-bottom: 0.25em;
  }
</style>)
    (expect output.strip).not_to include %(<script src="https://cdn.jsdelivr.net/chartist.js/)
  end
  it 'if chartistdir is defined, should append the required styles and scripts relative based (chartist.js)' do
    input = <<~ADOC
      :chart-engine: chartist
      :chartistdir: ../chartist

      [chart#month-stats,line]
      ....
      January,February,March,April,May,June,July
      28,48,40,19,86,27,90
      65,59,80,81,56,55,40
      ....

      chart::#{fixturedir}/sample-data.csv[line]
    ADOC
    output = Asciidoctor.convert(input, standalone: true)
    (expect output.strip).to include %(<link rel="stylesheet" href="../chartist/chartist.min.css">
<script src="../chartist/chartist.min.js"></script>
<style>
  .chartblock {
    margin-bottom: 1.25em;
  }
  .chartblock > .title {
    text-rendering: optimizeLegibility;
    text-align: left;
    font-size: 1rem;
    font-style: italic;
    line-height: 1.45;
    color: #7a2518;
    font-weight: 400;
  }
  .chartblock > .chartjs-content {
    position: relative;
    margin-bottom: 0.25em;
  }
</style>)
    (expect output.strip).not_to include %(<script src="https://cdn.jsdelivr.net/chartist.js/)
    (expect output.strip).not_to include %(<script src="https://cdnjs.cloudflare.com/ajax/libs/c3/)
  end
end
