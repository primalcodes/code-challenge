# frozen_string_literal: true

module GoogleCarouselParser
  # Shared logic for parsing Google carousels
  module SharedLogic
    BASE_URL = 'https://www.google.com'

    def script_image_data(image_id:)
      # If the image_id is nil, it may likely mean the image data is not in any of the script tags.
      # User would have to click "Show more" to load the image data.
      return nil if image_id.nil?

      # The regular expression is used to match and capture the base64 image data and the image ID.
      # var\s?s='([^']+)'; - Matches "var s='base64_data';" and captures the base64_data.
      # var\s?ii=\['([^']+)'\]; - Matches "var ii=['image_id'];" and captures the image_id.
      # Extract base64 image data and image ID directly
      matches = scripts.flat_map do |script|
        script.scan(/var\s?s='([^']+)';var\s?ii=\['#{Regexp.escape(image_id)}'\];/)
      end
      return nil if matches.empty?

      # The base64 image data is the first capture group
      matches.first.first
    end
  end
end
