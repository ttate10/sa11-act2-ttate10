def extract_urls(text)
  url_regex = %r{
    \b
    (?:https?|ftp)://
    [^\s/$.?#].[^\s]*?
    (?=[\s,;!]|$)
  }ix

  text.scan(url_regex)
end

sample_text = "Visit our site at http://www.example.org for more information. Check out our search page at https://example.com/search?q=ruby+regex. Don’t forget to ftp our resources at ftp://example.com/resources. Visit http://example.com!"

puts extract_urls(sample_text)