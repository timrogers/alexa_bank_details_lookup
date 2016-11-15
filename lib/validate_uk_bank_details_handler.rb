require 'alexa_skills_ruby'
require_relative 'bank_details_lookup_service'

class ValidateUkBankDetailsHandler < AlexaSkillsRuby::Handler
  on_intent("ValidateUkBankDetails") do
    account_number = request.intent.slots["AccountNumber"]
    sort_code = request.intent.slots["SortCode"]

    begin
      service = BankDetailsLookupService.
        new(access_token: Prius.get(:gocardless_access_token))

      gocardless_response = service.look_up(account_number: account_number,
                                            sort_code: sort_code)

      response.set_output_speech_text("Those bank details are valid, and belong to " \
                                      "#{gocardless_response.bank_name}.")

      logger.info "Successfully looked up bank details belonging to " \
                  "#{gocardless_response.bank_name}"
    rescue GoCardlessPro::ValidationError => exception
      logger.error "Validation failure when looking up bank details: #{exception.to_s}"

      response.set_output_speech_text("Those bank details are invalid.")
    rescue GoCardlessPro::GoCardlessError => exception
      logger.error "Unknown GC failure when looking up bank details: #{exception.to_s}"

      response.set_output_speech_text("Sorry, something went wrong while looking up " \
                                      "those bank details.")
    end
  end
end
