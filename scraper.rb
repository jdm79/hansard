require 'rubygems'
require 'chatterbot/dsl'
require 'logger'
require 'nokogiri'
require 'json'
require 'httparty'


def url_scraper

  @detail_urls = []
  @issues = ""
  url = 'https://hansard.parliament.uk/lords/2020-02-24'
  unparsed_page = HTTParty.get(url)
  parsed_page = Nokogiri::HTML(unparsed_page)

  parsed_page.css('div.debate-by-links.panel-group a').map do |link|
    @detail_urls << link.text
  end
  @detail_urls.shift
  @detail_urls.pop
  @detail_urls.pop
  @detail_urls.pop

  @detail_urls.uniq.sort.each do | issue |
    issue = issue.strip
    @issues += issue + ", "
  end
    @issues = @issues.chop.chop
    puts "Today, the Lords discussed: " + @issues
    # tweet "Today, the Lords discussed: " + @issues
end

url_scraper