# frozen_string_literal: true

module Teletype
  # Prints lines of text to screen and handles key strokes.
  class Page
    def initialize(lines, screen, stats)
      @lines = lines.map { |line| line.gsub("\t", '⇥') }
      @screen = screen
      @stats = stats
      @y = -1
    end

    def fetch
      loop do
        @line = @lines.shift
        @y += 1
        break if @line.nil? || @line.strip.length.positive?
      end

      # skip white spaces at the beginning of a line
      @x = @line&.match(/[[:graph:]]/)&.pre_match&.length || 0
    end

    def run
      @screen.fill(@lines.map { |line| default(line) })

      fetch
      to(@x, @y)

      loop do
        break if @lines.empty? && @line.nil?

        char = Key.read

        case char
        when '⏻'
          exit
        when '⌫'
          erase
        else
          advance(char)
        end

        @screen.log(@stats.rankings)
      end
    end

    def advance(char)
      at = @line[@x]
      if char == at
        @stats.hit!(at)
        print(correct(char))
      else
        @stats.miss!(at)
        print(wrong(visible(char)))
      end
      @x += 1
      fetch if @x == @line.length
      to(@x, @y)
    end

    def erase
      return unless @x.positive?

      @x -= 1
      to(@x, @y)
      print default(@line[@x])
      to(@x, @y)
    end

    def to(x, y)
      @screen.to(x, y)
    end

    def visible(char)
      case char
      when ' ' then '␣'
      when "\n" then '↵'
      when ("\u0001".."\u001A") then '⌃' # Ctrl[a-z]
      when /^\e/ then '�'
      else; char
      end
    end

    def default(str)
      "\e[94m#{str}\e[0m"
    end

    def correct(str)
      "\e[2;32m#{str}\e[0m"
    end

    def wrong(str)
      "\e[91m#{str}\e[0m"
    end
  end
end
