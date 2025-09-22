# frozen_string_literal: true

module Solargraph
  module Convention
    class Gemspec < Base
      def local source_map
        return Convention::Base::EMPTY_ENVIRON unless File.basename(source_map.filename).end_with?('.gemspec')
        @environ ||= Environ.new(
          requires: ['rubygems'],
          pins: [
            Solargraph::Pin::Reference::Override.from_comment(
              'Gem::Specification.new',
              %(
@yieldparam [self]
              ),
              source: :gemspec
            )
          ]
        )
      end
    end
  end
end
