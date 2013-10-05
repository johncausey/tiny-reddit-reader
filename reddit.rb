#!/bin/env ruby
require 'net/http'

if RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/
  key = "start"
elsif RbConfig::CONFIG['host_os'] =~ /darwin/
  key = "open"
elsif RbConfig::CONFIG['host_os'] =~ /linux|bsd/
  key = "xdg-open"
end

imgur_regex = /https?:\/\/i.?i?mgur.com\/[a-zA-Z0-9]a?\/?[a-zA-Z0-9]+[.]?\w{3}?/

ARGV.map! { |sub| "r/#{sub}" }
ARGV.each do |subreddit|
  request = Net::HTTP.get_response(URI.parse("http://www.reddit.com/#{subreddit}.json")).body.to_s
  ary = []
  links = request.scan(imgur_regex).to_a
  links.uniq.each {|li| ary << li }
  ary.each {|a| system "#{key} #{a}" }
end
