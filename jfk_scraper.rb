require 'nokogiri'
require 'httparty'
require 'csv'

# This script is in accordance with https://www.archives.gov/robots.txt
# Used to jumpstart the Document database

BASE_URL = "https://www.archives.gov/research/jfk/release-2025"

response = HTTParty.get(BASE_URL)

if response.code != 200
    puts "Failes to fetch page: #{response.code}"
    exit
end

doc = Nokogiri::HTML(response.body)

links = []

# Grab all pdf links
doc.css("a").each do |link|
    href = link["href"]
    next unless href && href.end_with?(".pdf")

    url = if href.start_with?("http")
        href
        else
            escaped_href = URI::DEFAULT_PARSER.escape(href)
            URI.join("https://www.archives.gov/", escaped_href).to_s
        end
    
    title = link.text.strip

    links << {title: title, url: url}
end

CSV.open("jfk_release_2025.csv", "w") do |csv|
    csv << ["title", "source_url"]

    links.each do |link|
        csv << [link[:title], link[:url]]
    end
end

puts "Scraped #{links.size} links and saved to jfk_release_2025.csv"