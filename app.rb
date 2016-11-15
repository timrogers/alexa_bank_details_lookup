require 'sinatra'
require 'gocardless_pro'
require 'dotenv'
require 'alexa_skills_ruby'
require_relative 'lib/validate_uk_bank_details_handler'

Dotenv.load
Prius.load(:gocardless_access_token)
Prius.load(:alexa_application_id)

post '/service' do
  content_type :json

  handler = ValidateUkBankDetailsHandler.new(
    application_id: Prius.get(:alexa_application_id),
    logger: logger
  )

  begin
    handler.handle(request.body.read)
  rescue AlexaSkillsRuby::InvalidApplicationId => exception
    logger.error exception.to_s
    403
  end
end
