# frozen_string_literal: true

module Teletype
  class Stats
    def initialize
      @keys = {}
    end

    def hit!(key)
      lookup(key).hit!
    end

    def miss!(key)
      lookup(key).miss!
    end

    def lookup(key)
      k = key.downcase
      @keys[k] ||= Click.new(k)
    end

    def ranking
      @keys.values.sort.map(&:to_s)
    end

    class Click
      attr_accessor :key, :hit, :miss

      def initialize(key, hit: 0, miss: 0)
        @key = key
        @hit = hit
        @miss = miss
      end

      def hit!
        @hit += 1
      end

      def miss!
        @miss += 1
      end

      def rate
        return 0 if total.zero?

        hit / total.to_f
      end

      def total
        hit + miss
      end

      def <=>(other)
        [rate, key] <=> [other.rate, other.key]
      end

      def to_s
        case key
        when "\n", "\r" then '↵'
        when ' ' then '␣'
        else; key
        end
      end
    end
  end
end
