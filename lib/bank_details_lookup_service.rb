# frozen_string_literal: true
require 'gocardless_pro'

class BankDetailsLookupService
  def initialize(access_token:)
    @access_token = access_token
  end

  def look_up(account_number:, sort_code:)
    client.bank_details_lookups.create(
      params: {
        country_code: 'GB',
        account_number: account_number,
        branch_code: sort_code
      }
    )
  end

  private

  attr_reader :access_token

  def client
    @client ||= GoCardlessPro::Client.new(access_token: access_token)
  end
end
