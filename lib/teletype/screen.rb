# frozen_string_literal: true

module Teletype
  class Screen
    attr_accessor :height, :width, :top, :left

    def initialize(height:, width:)
      @maxh, @maxw = $stdout.winsize

      if @maxh > height
        @height = height
        @top = (@maxh - height) / 2
      else
        @height = @maxh
        @top = 0
      end

      if @maxw > width
        @width = width
        @left = (@maxw - width) / 2
      else
        @width = @maxw
        @left = 0
      end

      at_exit { $stdout.clear_screen }
    end

    def to(x, y)
      $stdout.goto(@top + y, @left + x)
    end

    def fill(lines)
      invisible do
        $stdout.clear_screen

        lines.each_with_index do |line, index|
          $stdout.goto(@top + index, @left)
          $stdout.puts line
        end
      end
    end

    def log(*lines)
      original = $stdin.cursor
      invisible do
        lines.each_with_index do |line, index|
          $stdout.goto(@top + @height + 5 + index, @left)
          $stdout.print "\e[90;104m#{line}\e[0m"
          $stdout.erase_line(0)
        end
      end
      $stdout.cursor = original if original
    end

    def invisible
      $stdout.print "\e[?25l"
      yield
    ensure
      $stdout.print "\e[?25h"
    end
  end
end
