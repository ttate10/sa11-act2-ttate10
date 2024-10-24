# frozen_string_literal: true

require 'invoice_parser'

# NOTE: Do not modify the tests.

RSpec.describe 'Invoice Parsing' do
  describe '#parse_invoices' do
    it 'parses valid invoice entries' do
      invoice_entries = <<-INVOICES
2023-03-01 - INV001 - Acme Corp - $1000
2023-03-02 - INV002 - Beta LLC - $2050.75
2023-03-03 - INV003 - Gamma Inc - $3,500
      INVOICES

      expected_output = [
        { date: '2023-03-01', invoice_number: 'INV001', client: 'Acme Corp', amount: '$1000' },
        { date: '2023-03-02', invoice_number: 'INV002', client: 'Beta LLC', amount: '$2050.75' },
        { date: '2023-03-03', invoice_number: 'INV003', client: 'Gamma Inc', amount: '$3,500' }
      ]

      expect(parse_invoices(invoice_entries)).to eq(expected_output)
    end

    it 'handles client names with special characters' do
      invoice_entries = <<-INVOICES
2023-03-01 - INV001 - O'Connor Ltd. - $1000
2023-03-02 - INV002 - Smith & Sons, Inc. - $2050.75
      INVOICES

      expected_output = [
        { date: '2023-03-01', invoice_number: 'INV001', client: "O'Connor Ltd.", amount: '$1000' },
        { date: '2023-03-02', invoice_number: 'INV002', client: 'Smith & Sons, Inc.', amount: '$2050.75' }
      ]

      expect(parse_invoices(invoice_entries)).to eq(expected_output)
    end

    it 'handles entries with extra spaces or tabs' do
      invoice_entries = <<-INVOICES
2023-03-01  -  INV001  -  Acme Corp  -  $1000
2023-03-02\t-\tINV002\t-\tBeta LLC\t-\t$2050.75
      INVOICES

      expected_output = [
        { date: '2023-03-01', invoice_number: 'INV001', client: 'Acme Corp', amount: '$1000' },
        { date: '2023-03-02', invoice_number: 'INV002', client: 'Beta LLC', amount: '$2050.75' }
      ]

      expect(parse_invoices(invoice_entries)).to eq(expected_output)
    end

    it 'handles amounts with thousand separators' do
      invoice_entries = <<-INVOICES
2023-03-01 - INV001 - Acme Corp - $1,000
2023-03-02 - INV002 - Beta LLC - $10,000.50
      INVOICES

      expected_output = [
        { date: '2023-03-01', invoice_number: 'INV001', client: 'Acme Corp', amount: '$1,000' },
        { date: '2023-03-02', invoice_number: 'INV002', client: 'Beta LLC', amount: '$10,000.50' }
      ]

      expect(parse_invoices(invoice_entries)).to eq(expected_output)
    end

    it 'handles invalid dates' do
      invoice_entries = <<-INVOICES
03/01/2023 - INV001 - Acme Corp - $1000
2023.03.02 - INV002 - Beta LLC - $2050.75
      INVOICES

      expect(parse_invoices(invoice_entries)).to eq([])
    end

    it 'handles amounts not in US dollars' do
      invoice_entries = <<-INVOICES
2023-03-01 - INV001 - Acme Corp - €1000
2023-03-02 - INV002 - Beta LLC - 1000
      INVOICES

      expect(parse_invoices(invoice_entries)).to eq([])
    end

    it 'handles missing fields or malformed lines' do
      invoice_entries = <<-INVOICES
2023-03-01 - INV001 - $1000
2023-03-02 - INV002 - Beta LLC
      INVOICES

      expect(parse_invoices(invoice_entries)).to eq([])
    end

    it 'handles incorrectly formatted amounts' do
      invoice_entries = <<-INVOICES
2023-03-01 - INV001 - Acme Corp - $1000.7
2023-03-02 - INV002 - Beta LLC - $1000.789
      INVOICES

      expect(parse_invoices(invoice_entries)).to eq([])
    end

    it 'handles an empty string' do
      expect(parse_invoices('')).to eq([])
    end

    it 'handles a string with only valid invoices' do
      invoice_entries = <<-INVOICES
2023-03-01 - INV001 - Acme Corp - $1000
2023-03-02 - INV002 - Beta LLC - $2050.75
2023-03-03 - INV003 - Gamma Inc - $3,500
      INVOICES

      expected_output = [
        { date: '2023-03-01', invoice_number: 'INV001', client: 'Acme Corp', amount: '$1000' },
        { date: '2023-03-02', invoice_number: 'INV002', client: 'Beta LLC', amount: '$2050.75' },
        { date: '2023-03-03', invoice_number: 'INV003', client: 'Gamma Inc', amount: '$3,500' }
      ]

      expect(parse_invoices(invoice_entries)).to eq(expected_output)
    end
  end
end