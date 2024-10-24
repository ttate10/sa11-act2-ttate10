def parse_invoices(invoice_entries)
  invoice_entries.scan(%r{
    (\d{4}-\d{2}-\d{2}) \s* - \s*   
    (INV\d+) \s* - \s*               
    (.+?) \s* - \s*                 
    (\$\d+(?:,\d{3})*(?:\.\d{2})?)
  }x).map do |date, invoice_number, client, amount|
    { date: date, invoice_number: invoice_number, client: client.strip, amount: amount }
  end
end