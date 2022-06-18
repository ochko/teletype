# frozen_string_literal: true

module Teletype
  # Pager divides lines of text into proper screen size and provides page suggestion
  # based on statistics of click accuracy.
  class Pager
    SUGGEST = 3

    def initialize(lines, stats, height)
      @lines = lines
      @stats = stats
      @height = height
    end

    def each
      @lines.each_slice(@height).map do |lines|
        yield lines

        loop do
          suggestions = @stats.suggestions(@lines)
          break if suggestions.empty?

          yield pick(suggestions)
        end
      end
    end

    def pick(suggestions)
      index = 0.0
      @lines.sort_by { |line| suggestions.map { |keys| -line.scan(keys).count }.sum + (index += 0.0001) }.first(SUGGEST)
    end
  end
end
