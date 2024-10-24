class InvoiceParsingError < StandardError; end

def parse_invoice(invoice)
  raise InvoiceParsingError, "Error: Empty input string" if invoice == ""
  invoice.split("\n").map do |line|
    date, invoice_number, client, amount = line.split(/\s+-\s+/)
    
    # puts date, invoice_number, client, amount
    date.nil? ? (raise InvoiceParsingError, "Error: Invalid date format") : date = date.scan(/\d{4}-\d{2}-\d{2}/).first
    invoice_number.nil? ? (raise InvoiceParsingError, "Error: Missing fields or malformed lines") : invoice_number = invoice_number.scan(/[A-Z0-9]+/).first
    client.nil? ? (raise InvoiceParsingError, "Error: Missing fields or malformed lines") : client = client.strip
    amount.nil? ? (raise InvoiceParsingError, "Error: Missing fields or malformed lines") : !amount.start_with?("$") ? (raise InvoiceParsingError, "Error: Amount not in US Dollars") : amount = amount.scan(/^\$[\d,]+(?:\.\d\d)?$/).first
    
    raise InvoiceParsingError, "Error: Invalid date format" if date.nil?
    raise InvoiceParsingError, "Error: Missing fields or malformed lines" if invoice_number.nil?
    raise InvoiceParsingError, "Error: Missing fields or malformed lines" if client.nil?
    raise InvoiceParsingError, "Error: Incorrectly formatted amounts" if amount.nil?
    
    { date: date, invoice_number: invoice_number, client: client, amount: amount }
  end
end