# frozen_string_literal: true

module Asciidoctor
  module Chart
    module Converter
      class Base
        def handles? type
          respond_to? %(convert_#{type}_chart)
        end
      end
    end
  end
end
