require 'rubygems'
require 'chatterbot/dsl'
require 'logger'
require 'nokogiri'
require 'json'
require 'httparty'


def url_scraper
  # refactor all of this into methods
  @detail_urls = []
  @issues = ""

  url = 'https://hansard.parliament.uk/lords/'
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

    @issues = @issues.chop
    if @issues !=  ""
      check = @issues.split("")
      if check.length <= 280
        puts "Today, the Lords discussed: " + @issues
        tweet "Today, the Lords discussed: " + @issues
      else
        first, second = @issues.chars.each_slice(@issues.length / 2).map(&:join)
        tweet "Today the Lords discussed: " + first
        sleep 10
        tweet  "Cont'd..." + second.chop
      end
    else
      tweet "Nothing to see here. The Lords are not debating today."
    end
end

loop do
  url_scraper
  sleep 86400
end

tweet "Nothing to see here. The Lords are not debating today."
