require 'net/http'
require 'json'
require 'csv'

API_KEY = '1096f2ce58d157a8eafe0285'  # Введіть свій ключ API
BASE_URL = 'https://v6.exchangerate-api.com/v6'
base_currency = 'USD'
currencies = ['EUR', 'GBP', 'JPY', 'AUD', 'CAD']

def get_exchange_rates(base_currency)
  url = "#{BASE_URL}/#{API_KEY}/latest/#{base_currency}"
  uri = URI(url)

  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true

  begin
    response = http.get(uri.request_uri)
    JSON.parse(response.body)
  rescue JSON::ParserError
    puts 'Неможливо розібрати відповідь. Перевірте, чи правильний API-ключ і URL.'
    exit
  rescue Net::OpenTimeout, Net::ReadTimeout
    puts 'Тайм-аут з\'єднання! Будь ласка, спробуйте пізніше.'
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
        puts "Курс для #{currency} не знайдено."
      end
    end
  end
  puts 'Дані успішно збережено у файл exchange_rates.csv.'
else
  puts "Помилка: #{exchange_data ? exchange_data['error-type'] : 'невідома помилка'}"
end
