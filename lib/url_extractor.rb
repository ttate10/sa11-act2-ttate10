def extract_urls(input_string)
  urls = input_string.scan(/\b(?:https?|ftp):\/\/\S+\b/)
  urls.each { |url| }
end

# input_string = "Check out these links: https://example.com, https://www.example.com, http://blog.example.com, http://example.com:8080, http://example.com/about, http://example.com/search?q=ruby, http://example.com/page#section."
# p extract_urls(input_string)
