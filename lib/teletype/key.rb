# frozen_string_literal: true

require 'io/wait'
require 'io/console'

module Teletype
  class Key
    DICTIONARY = {
      "\e" => '␛',
      "\e[1;5A" => '↥', # ctrl-up
      "\e[1;5B" => '↧', # ctrl-down
      "\e[1;5C" => '↦', # ctrl-right
      "\e[1;5D" => '↤', # ctrl-left

      "\e[1~" => '⌂', # home
      "\e[2~" => '⎀', # insert
      "\e[3~" => '⌦', # delete
      "\e[3;2~" => '↱', # shift+delete
      "\e[3;5~" => '↪', # ctrl+delete
      "\e[4~" => '↘', # end
      "\e[5~" => '⇞', # page up
      "\e[6~" => '⇟', # page down
      "\e[7~" => '⌂', # home
      "\e[8~" => '↘', # end

      "\e[A" => '↑',
      "\e[B" => '↓',
      "\e[C" => '→',
      "\e[D" => '←',
      "\e[E" => '⇲', # clear
      "\e[H" => '⌂', # home
      "\e[F" => '↘', # end
      "\e[Z" => '⇤', # backtab(shift + tab)

      "\u0003" => '⏻',
      "\u007F" => '⌫', # backspace
      "\r" => "\n",
      "\t" => '⇥'
    }.freeze

    def self.read
      blocking = true
      chars = []
      $stdin.raw do
        $stdin.noecho do
          loop do
            if blocking
              chars << $stdin.getc
              blocking = false
            elsif $stdin.ready?
              chars << $stdin.getc
            else
              key = chars.join
              return DICTIONARY[key] || key
            end
          end
        end
      end
    end
  end
end
