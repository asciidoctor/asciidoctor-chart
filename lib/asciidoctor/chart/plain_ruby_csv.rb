# frozen_string_literal: true

module Asciidoctor
  module Chart
    class PlainRubyCSV
      def self.parse data
        result = []
        data.each_line do |line|
          line_chomp = line.chomp
          result.push line_chomp.split ','
        end
        result
      end

      def self.read(filename)
        result = []
        (File.open filename).each do |line|
          line_chomp = line.chomp
          result.push line_chomp.split ','
        end
        result
      end
    end
  end
end
