module Jekyll
  module Converters
    class Markdown < Converter
      def output_ext(ext)
        ".xhtml"
      end
    end
  end
end