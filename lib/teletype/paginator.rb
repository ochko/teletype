# frozen_string_literal: true

require 'digest'

module Teletype
  # Pager divides lines of text into proper screen size and provides page suggestion
  # based on statistics of click accuracy.
  class Paginator
    def initialize(profile, text, suggest:, screen:, stats:)
      @screen = screen
      @stats = stats
      @suggest = suggest

      @lines = split(text, @screen.width)

      @linenum = 0
      @pagefile = File.join(profile, "page-#{Digest::MD5.hexdigest(text)}")
    end

    def save
      File.write(@pagefile, @linenum) if @linenum.positive?
    end

    def run
      prev = File.exist?(@pagefile) ? Integer(File.read(@pagefile).strip) : 0
      @lines.each_slice(@screen.height) do |lines|
        @linenum += @screen.height
        next if @linenum < prev

        Page.new(lines, @screen, @stats).run

        loop do
          suggestions = @stats.suggestions
          break if suggestions.empty?

          Page.new(pick(suggestions), @screen, @stats).run
        end
      end
    end

    def pick(suggestions)
      index = 0.0 # preserve the original order
      matches = ->(line) { suggestions.map { |keys| line.scan(keys).count }.sum - (index += 0.0001) }
      @lines.sort_by { |line| matches.call(line) }.last(@suggest)
    end

    def split(text, length)
      lines = []
      text.each_line do |line|
        line.chars.each_slice(length) do |slice|
          lines << slice.join
        end
      end
      lines
    end
  end
end
