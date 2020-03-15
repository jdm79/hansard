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
  @first = ""
  @second = ""

  url = 'https://hansard.parliament.uk/lords/'
  unparsed_page = HTTParty.get(url)
  parsed_page = Nokogiri::HTML(unparsed_page)

  # parsed_page.css('div.debate-by-links.panel-group a').map do |link|
  parsed_page.css('div#debates-collapse-LordsChamber #sectionTree li a').map do |link|
    @detail_urls << link.text
  end


  @detail_urls.uniq.sort.each do | issue |
    issue = issue.strip
    @issues += issue + ", "
  end

    
    @issues = @issues.chop.chop # this gets rid of the trailing comma on last issue
    if @issues !=  ""
      check = @issues.split("")
      if check.length <= 262
        puts "Today, the Lords discussed: " + @issues
        tweet "Today, the Lords discussed: " + @issues
      else
        first, third = @issues.chars.each_slice(@issues.length / 2).map(&:join)
        check = first.split("")
        if check.length <= 262
        puts "Today, the Lords discussed: " + first
        tweet "Today, the Lords discussed: " + first
        sleep 5
        puts "Cont'd... " + third
        tweet "Cont'd... " + second
        else
          first, second = first.chars.each_slice(first.length / 2).map(&:join)
          check = first.split("")
          if check.length <= 262
            puts "Today, the Lords discussed: " + first
            tweet "Today, the Lords discussed: " + first
            sleep 5
            puts "Cont'd... " + second
            tweet "Cont'd... " + second
            puts "Cont'd... " + third
            tweet "Cont'd... " + third
          end
        end
      end
    else
      # puts "Nothing to see here. The Lords are not debating today."
      tweet "Nothing to see here. The Lords are not debating today."
    end
end

loop do
  url_scraper
  sleep 86400
end