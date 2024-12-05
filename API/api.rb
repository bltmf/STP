require 'net/http'
require 'json'
require 'csv'

API_KEY = '1096f2ce58d157a8eafe0285'
BASE_URL = 'https://v6.exchangerate-api.com/v6'
base_currency = 'USD'
currencies = ['EUR', 'GBP', 'JPY', 'AUD', 'CAD']

def get_exchange_rates(base_currency)
  url = "#{BASE_URL}/#{API_KEY}/latest/#{base_currency}"
  uri = URI(url)

  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.open_timeout = 10
  http.read_timeout = 10

  begin
    response = http.get(uri.request_uri)
    if response.code.to_i == 200
      JSON.parse(response.body)
    else
      puts "HTTP error: #{response.code} - #{response.message}"
      puts response.body
      exit
    end
  rescue Net::OpenTimeout, Net::ReadTimeout
    puts 'Time out!'
    exit
  rescue JSON::ParserError
    puts 'API/URL error'
    exit
  end
end

exchange_data = get_exchange_rates(base_currency)

if exchange_data && exchange_data['result'] == 'success'
  rates = exchange_data['conversion_rates']
  CSV.open('exchange_rates.csv', 'w') do |csv|
    csv << ['Валюта', 'Курс']
    currencies.each do |currency|
      if rates[currency]
        csv << [currency, rates[currency]]
      else
        puts "Курс #{currency} not found"
      end
    end
  end
  puts 'Save! - exchange_rates.csv'
else
  puts "Error: #{exchange_data ? exchange_data['error-type'] : 'unknow error'}"
end
