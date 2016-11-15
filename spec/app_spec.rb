# frozen_string_literal: true
require File.expand_path '../spec_helper.rb', __FILE__

describe 'Alexa Bank Details Lookup application' do
  let(:request_path) { File.expand_path('../fixtures/request.json', __FILE__) }
  let(:request_file) { File.read(request_path) }
  let(:request_data) { JSON.parse(request_file) }

  let(:post_service) { post '/service', request_data.to_json }

  context 'for valid bank details' do
    it 'returns a success message with the bank name' do
      VCR.use_cassette('gocardless/bank_details_lookups_valid') do
        post_service

        expect(last_response.body).to include('valid')
        expect(last_response.body).to include('TSB BANK PLC')
      end
    end
  end

  context 'for invalid bank details' do
    before { request_data['request']['intent']['slots']['SortCode']['value'] = '1234' }

    it 'returns a message saying the details are invalid' do
      VCR.use_cassette('gocardless/bank_details_lookups_invalid') do
        post_service

        expect(last_response.body).to include('invalid')
      end
    end
  end
end
