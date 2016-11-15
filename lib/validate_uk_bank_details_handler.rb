# frozen_string_literal: true
require 'alexa_skills_ruby'
require_relative 'bank_details_lookup_service'

class ValidateUkBankDetailsHandler < AlexaSkillsRuby::Handler
  on_intent('ValidateUkBankDetails') { look_up_bank_details }

  private

  def look_up_bank_details
    bank_details_lookup = bank_details_lookups.create(account_number: account_number,
                                                      sort_code: sort_code)

    valid_bank_details_message(bank_details_lookup.bank_name)
  rescue GoCardlessPro::ValidationError => exception
    invalid_bank_details_message(exception)
  rescue GoCardlessPro::GoCardlessError => exception
    generic_error_message(exception)
  end

  def account_number
    request.intent.slots['AccountNumber']
  end

  def sort_code
    request.intent.slots['SortCode']
  end

  def bank_details_lookups
    BankDetailsLookupService.new(access_token: Prius.get(:gocardless_access_token))
  end

  def valid_bank_details_message(bank_name)
    logger.info 'Successfully looked up bank details belonging to #{bank_name}'

    response.set_output_speech_text('Those bank details are valid, and belong to ' \
                                    "#{bank_name}.")
  end

  def invalid_bank_details_message(exception)
    logger.error "Validation failure when looking up bank details: #{exception}"
    response.set_output_speech_text('Those bank details are invalid.')
  end

  def generic_error_message(exception)
    logger.error "Unknown GoCardless error when looking up bank details: #{exception}"

    response.set_output_speech_text('Sorry, something went wrong while looking up ' \
                                    'those bank details.')
  end
end
