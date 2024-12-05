require 'rspec'
require 'webmock/rspec'
require 'csv'
require_relative 'api.rb'

RSpec.describe 'Exchange Rate API' do
  before do
    stub_request(:get, "https://v6.exchangerate-api.com/v6/1096f2ce58d157a8eafe0285/latest/USD")
      .to_return(
        status: 200,
        body: '{"result":"success","conversion_rates":{"EUR":0.85,"GBP":0.75,"JPY":110.54}}',
        headers: { 'Content-Type' => 'application/json' }
      )
  end

  describe 'HTTP-request to API' do
    it 'returns a successful response' do
      response = get_exchange_rates('USD')

      expect(response['result']).to eq('success')
      expect(response['conversion_rates']).to be_a(Hash)
      expect(response['conversion_rates']).to have_key('EUR')
      expect(response['conversion_rates']).to have_key('GBP')
      expect(response['conversion_rates']).to have_key('JPY')
    end
  end

  describe 'Data processing' do
    it 'correctly draws and collects data' do
      response = get_exchange_rates('USD')

      expect(response['conversion_rates']).to include('EUR', 'GBP', 'JPY')

      expect(response['conversion_rates']['EUR']).to eq(0.85)
      expect(response['conversion_rates']['GBP']).to eq(0.75)
      expect(response['conversion_rates']['JPY']).to eq(110.54)
    end
  end

  describe 'Save CSV' do
    it 'create CSV' do
      response = get_exchange_rates('USD')
      
      CSV.open('exchange_rates_test.csv', 'w') do |csv|
        csv << ['Валюта', 'Курс']
        response['conversion_rates'].each do |currency, rate|
          csv << [currency, rate]
        end
      end

      expect(File).to exist('exchange_rates_test.csv')

      csv_content = CSV.read('exchange_rates_test.csv')
      expect(csv_content).to include(['Валюта', 'Курс'])
      expect(csv_content).to include(['EUR', '0.85'])
      expect(csv_content).to include(['GBP', '0.75'])
      expect(csv_content).to include(['JPY', '110.54'])
    end
  end
end
