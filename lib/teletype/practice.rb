# frozen_string_literal: true

module Teletype
  # Initializes screen size and click stats, then start the practice page by page.
  class Practice
    def initialize(text, height: 5, width: 120)
      @screen = Screen.new(height: height, width: width)
      @stats = Stats.new

      @lines = []
      text.each_line do |line|
        line.chars.each_slice(@screen.width) do |slice|
          @lines << slice.join
        end
      end

      @pager = Pager.new(@lines, @stats, @screen.height)
    end

    def start
      @pager.each do |lines|
        Page.new(lines, @screen, @stats).run
      end
    end
  end
end
