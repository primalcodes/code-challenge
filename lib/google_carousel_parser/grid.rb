# frozen_string_literal: true

require 'nokogiri'
require_relative 'shared_logic'

module GoogleCarouselParser
  # Responsible for parsing "Grid" type carousels
  class Grid
    include SharedLogic

    CAROUSEL_SELECTOR = 'div[data-attrid^="kc:/"]'
    CAROUSEL_ITEMS_SELECTOR = '.iELo6'

    def initialize(html_doc:)
      @doc = html_doc # Nokogiri::HTML(html)
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
      carousel_node = doc.at_css(CAROUSEL_SELECTOR)
      return nil if carousel_node.nil?

      parse_carousel_items(carousel_node:)
    end

    def parse_carousel_items(carousel_node:)
      carousel_node.css(CAROUSEL_ITEMS_SELECTOR).map { |node| extract_carousel_item_data(node:) }
    end

    def extract_carousel_item_data(node:)
      link = extract_link(node:)
      link_value = link.nil? ? nil : "#{SharedLogic::BASE_URL}#{link}"
      image = extract_image(node:)
      name, extension = extract_name_and_extension(node:)

      { name: name, image: image, link: link_value, extensions: [extension].compact }
    end

    def extract_link(node:)
      a_tag = node.at_css('a')
      a_tag&.attributes&.[]('href')&.value
    end

    def extract_image(node:)
      img_tag = node.at_css('a img')
      script_image_data(image_id: img_tag&.attributes&.[]('id')&.value)
    end

    def extract_name_and_extension(node:)
      extension_tags = node.at_css('a').xpath('div/div')
      name = extension_tags[0]&.text
      extension = extension_tags[1]&.text
      extension = extension&.empty? ? nil : extension
      [name, extension]
    end
  end
end
