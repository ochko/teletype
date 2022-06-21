# frozen_string_literal: true

module Teletype
  # Stats keep track of hit/miss rate for pair of keys.
  # It also has suggestions for keys that need more practice.
  class Stats
    def initialize(profile, text)
      @file = File.join(profile, 'stats')
      @previous = nil
      @pairs = {}
      load(text)
    end

    def load(text)
      return unless File.exist?(@file)

      File.readlines(@file).each do |line|
        keys, hit, miss = line.split("\t")
        @pairs[keys] = Pair.new(keys,
                                hit: Integer(hit),
                                miss: Integer(miss),
                                available: text.scan(keys).count.positive?)
      end
    end

    def save
      File.write(@file, @pairs.map { |k, p| [k, p.hit, p.miss].join("\t") }.join("\n"))
    end

    def hit!(key)
      lookup(key)&.hit!
    end

    def miss!(key)
      lookup(key)&.miss!
    end

    def lookup(key)
      current = key.downcase
      keys = "#{@previous}#{current}"
      @previous = current
      return if keys.strip.length < 2

      @pairs[keys] ||= Pair.new(keys)
    end

    def suggestions
      @pairs.values.select(&:available).select(&:inefficient?).sort.map(&:keys)
    end

    def rankings
      @pairs.values.select(&:available).sort.first(10).map(&:to_s).join(' ')
    end

    # It implements hit/miss rate for second keystroke.
    # Key miss tends occur when preceded by a certain key.
    class Pair
      THRESHOLD = 0.7

      # hit/miss is for the second key
      attr_accessor :keys, :hit, :miss, :available

      def initialize(keys, hit: 0, miss: 0, available: true)
        @keys = keys
        @hit = hit
        @miss = miss
        @available = available
      end

      def inefficient?
        rate < THRESHOLD
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
        [rate, keys] <=> [other.rate, other.keys]
      end

      def to_s
        keys.gsub(/[\n\r]/, '↵').gsub(' ', '␣')
      end
    end
  end
end
