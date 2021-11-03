# frozen_string_literal: true

module Teletype
  class Pager
    SUGGEST = 1

    def initialize(lines, stats, height)
      @lines = lines
      @stats = stats
      @height = height
    end

    def each
      @lines.each_slice(@height).map do |lines|
        yield lines

        loop do
          suggestions = @stats.suggestions
          break if suggestions.empty?

          yield pick(suggestions)
        end
      end
    end

    def pick(suggestions)
      index = 0.0
      @lines.sort_by {|line| suggestions.map {|keys| -line.scan(keys).count}.sum + (index += 0.0001)}.first(SUGGEST)
    end
  end
end
