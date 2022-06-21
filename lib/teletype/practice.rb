# frozen_string_literal: true

module Teletype
  # Initializes screen size and click stats, then start the practice page by page.
  class Practice
    def initialize(profile, text:, height:, width:, suggest:, verbose:)
      @stats = Stats.new(profile, text)
      @paginator = Paginator.new(
        profile, text,
        height: height,
        width: width,
        suggest: suggest,
        verbose: verbose,
        stats: @stats
      )
    end

    def start
      at_exit do
        @stats.save
        @paginator.save
      end

      @paginator.run
    end
  end
end
