# frozen_string_literal: true

require 'nokogiri'
require_relative '../google_carousel_parser'

module GoogleCarouselParser
  # Responsible for parsing "Tab List" type carousels
  class TabList
    include GoogleCarouselParser

    CAROUSEL_SELECTOR = '[role="group"]'
    CAROUSEL_ITEMS_SELECTOR = '[role="tab"]'

    def initialize(html_doc:)
      @doc = html_doc
      @scripts = @doc.css('script').map(&:text)
    end

    def parse
      {
        artworks: parse_carousel || []
      }
    end

    private

    attr_reader :doc, :scripts

    def parse_carousel
      # wildcard selector to find the carousel node that contains a data-attrid beginning with: `kc:/`
      # carousel_node = doc.at_css('[role="tablist"]')
      carousel_node = doc.at_css(CAROUSEL_SELECTOR)
      return nil if carousel_node.nil?

      parse_carousel_items(carousel_node:)
    end

    def parse_carousel_items(carousel_node:)
      carousel_node.css(CAROUSEL_ITEMS_SELECTOR).map { |node| extract_carousel_item_data(node:) }
    end

    def extract_carousel_item_data(node:)
      anchor_node = node
      link = anchor_node&.attributes&.[]('href')&.value if anchor_node
      link_value = link.nil? ? nil : "#{GoogleCarouselParser::BASE_URL}#{link}"
      link_entity_name = anchor_node&.attributes&.[]('data-entityname')&.value
      link_title = anchor_node&.attributes&.[]('title')&.value if anchor_node
      extension_text = extract_extension(link_title:, link_entity_name:)
      image = extract_image(node: anchor_node) if anchor_node

      { name: link_entity_name, image: image, link: link_value, extensions: [extension_text].compact }
    end

    def extract_image(node:)
      img_tag = node.at_css('img')
      script_image_data(image_id: img_tag&.attributes&.[]('id')&.value)
    end

    def extract_extension(link_title:, link_entity_name:)
      extension_text = link_title&.gsub(link_entity_name, '')&.strip if link_entity_name
      extension_text&.empty? ? nil : extension_text
    end
  end
end
