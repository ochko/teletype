# frozen_string_literal: true

module Teletype
  class Practice
    def initialize(text, height: 25, width: 120)
      @screen = Screen.new(height: height, width: width)
      stats = Stats.new

      content = []
      text.each_line do |line|
        line.chars.each_slice(@screen.width) do |slice|
          content << slice.join
        end
      end

      @pages = content.each_slice(@screen.height).map do |lines|
        Page.new(lines, @screen, stats)
      end
    end

    def start
      at_exit do
        @screen.cleanup
      end

      loop do
        page = @pages.shift
        page.run
        @pages.push(page)
      end
    end
  end
end
