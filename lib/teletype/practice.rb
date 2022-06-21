# frozen_string_literal: true

module Teletype
  # Initializes screen size and click stats, then start the practice page by page.
  class Practice
    def initialize(text, stats:, screen:)
      @screen = screen
      @stats = stats

      @lines = []
      text.each_line do |line|
        line.chars.each_slice(@screen.width) do |slice|
          @lines << slice.join
        end
      end

      @pager = Pager.new(@lines, @stats, @screen.height)
    end

    def start
      at_exit { @stats.save }

      @pager.each do |lines|
        Page.new(lines, @screen, @stats).run
      end
    end
  end
end
