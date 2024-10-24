# frozen_string_literal: true

require 'url_extractor'

RSpec.describe 'URL Extraction' do
  describe '#extract_urls' do
    it 'extracts URLs with http and https' do
      expect(extract_urls('Visit http://example.com and https://www.example.com')).to eq(['http://example.com', 'https://www.example.com'])
    end

    it 'extracts URLs with ftp' do
      expect(extract_urls('Download from ftp://example.com')).to eq(['ftp://example.com'])
    end

    it 'extracts URLs with subdomains' do
      expect(extract_urls('Check http://blog.example.com')).to eq(['http://blog.example.com'])
    end

    it 'extracts URLs with port numbers' do
      expect(extract_urls('Access http://example.com:8080')).to eq(['http://example.com:8080'])
    end

    it 'extracts URLs with paths' do
      expect(extract_urls('Visit http://example.com/about')).to eq(['http://example.com/about'])
    end

    it 'extracts URLs with query parameters' do
      expect(extract_urls('Search http://example.com/search?q=ruby')).to eq(['http://example.com/search?q=ruby'])
    end

    it 'extracts URLs with fragments' do
      expect(extract_urls('Read http://example.com/page#section')).to eq(['http://example.com/page#section'])
    end

    it 'extracts URLs with unusual characters' do
      expect(extract_urls('Visit http://example-site.com/path_with_underscores')).to eq(['http://example-site.com/path_with_underscores'])
    end

    it 'extracts URLs with IP addresses' do
      expect(extract_urls('Access http://127.0.0.1')).to eq(['http://127.0.0.1'])
    end

    it 'handles edge cases with missing parts' do
      expect(extract_urls('Visit http://example.com!')).to eq(['http://example.com'])
    end

    it 'does not extract invalid URLs' do
      expect(extract_urls('Invalid URL htp://example.com')).to eq([])
    end

    it 'extracts URLs from a multi-line string' do
      text = "This is a\nhttp://multiline.com\ntext with\nhttp://multiple.com\nURLs"
      expect(extract_urls(text)).to eq(['http://multiline.com', 'http://multiple.com'])
    end

    it 'handles an empty string' do
      expect(extract_urls('')).to eq([])
    end

    it 'handles a string with only URLs' do
      expect(extract_urls('http://one.com http://two.com http://three.com')).to eq(['http://one.com', 'http://two.com', 'http://three.com'])
    end
  end
end