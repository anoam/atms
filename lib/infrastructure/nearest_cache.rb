# frozen_string_literal: true

module Infrastructure
  # Cache for nearest ATMs
  class NearestCache

    # Clears all cached data
    def clear!
      @cache = {}
    end

    # Tries to find response in cache
    #   if no data in cache - calls block and saves cache
    # @param latitude [Numeric]
    # @param longitude [Numeric]
    # @yield actual response building
    # @yieldreturn [String] response
    def with_cache(latitude:, longitude:)
      cache_key = key(latitude, longitude)
      return cache[cache_key] if cache.key?(cache_key)

      cache[cache_key] = yield
    end

    private

    def cache
      @cache ||= {}
    end

    def key(latitude, longitude)
      "#{latitude}_#{longitude}"
    end
  end
end
