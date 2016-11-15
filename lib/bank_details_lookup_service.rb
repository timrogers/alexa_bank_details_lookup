require 'gocardless_pro'

class BankDetailsLookupService
  def initialize(access_token:)
    @access_token = access_token
  end

  def look_up(account_number:, sort_code:)
    client.bank_details_lookups.create(
      params: {
        country_code: "GB",
        account_number: "55779911",
        branch_code: "200000"
      }
    )
  end

  private

  attr_reader :access_token

  def client
    @client ||= GoCardlessPro::Client.new(access_token: access_token)
  end
end
