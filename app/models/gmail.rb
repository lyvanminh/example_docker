# require 'google/apis/gmail_v1'
# require 'rmail'
#
# module Samples
#   # Examples for the Gmail API
#   #
#   # Sample usage:
#   #
#   #     $ ./google-api-samples gmail send 'Hello there!' \
#   #       --to='recipient@example.com' --from='user@example.com' \
#   #       --subject='Hello'
#   #
#   class Gmail < ApplicationRecord
#     Gmail = Google::Apis::GmailV1
#
#     desc 'get ID', 'Get a message for an id with the gmail API'
#     def get(id)
#       gmail = Gmail::GmailService.new
#       gmail.authorization = user_credentials_for(Gmail::AUTH_SCOPE)
#
#       result = gmail.get_user_message('me', id)
#       payload = result.payload
#       headers = payload.headers
#
#       date = headers.any? { |h| h.name == 'Date' } ? headers.find { |h| h.name == 'Date' }.value : ''
#       from = headers.any? { |h| h.name == 'From' } ? headers.find { |h| h.name == 'From' }.value : ''
#       to = headers.any? { |h| h.name == 'To' } ? headers.find { |h| h.name == 'To' }.value : ''
#       subject = headers.any? { |h| h.name == 'Subject' } ? headers.find { |h| h.name == 'Subject' }.value : ''
#
#       body = payload.body.data
#       if body.nil? && payload.parts.any?
#         body = payload.parts.map { |part| part.body.data }.join
#       end
#
#       puts "id: #{result.id}"
#       puts "date: #{date}"
#       puts "from: #{from}"
#       puts "to: #{to}"
#       puts "subject: #{subject}"
#       puts "body: #{body}"
#     end
#
#     desc 'send TEXT', 'Send a message with the gmail API'
#     method_option :to, type: :string, required: true
#     method_option :from, type: :string, required: true
#     method_option :subject, type: :string, required: true
#     def send(body)
#       gmail_scopes = [
#         "https://mail.google.com/",
#         "https://www.googleapis.com/auth/gmail.send",
#       ]
#       gmail = Gmail::GmailService.new
#       gmail.authorization = Google::Auth.get_application_default(gmail_scopes)
#       gmail.authorization = user_credentials_for(Gmail::AUTH_GMAIL_SEND)
#
#       message = RMail::Message.new
#       message.header['To'] = "lvm10296.2@gmail.com"
#       message.header['From'] = "lyvanminh1002@gmail.com"
#       message.header['Subject'] = "Test send mail"
#       message.body = body
#
#       gmail.send_user_message('me',
#                               upload_source: StringIO.new(message.to_s),
#                               content_type: 'message/rfc822')
#     end
#   end
# end
#
require "google/apis/gmail_v1"
require "googleauth"
require "googleauth/stores/file_token_store"
require "fileutils"

OOB_URI = "https://c829535ad8aa.ngrok.io/auth/google_oauth2/callback".freeze
APPLICATION_NAME = "Gmail API Ruby Quickstart".freeze
CREDENTIALS_PATH = "credentials.json".freeze
# The file token.yaml stores the user's access and refresh tokens, and is
# created automatically when the authorization flow completes for the first
# time.
TOKEN_PATH = "token.yaml".freeze
SCOPE = Google::Apis::GmailV1::AUTH_GMAIL_SEND

##
# Ensure valid credentials, either by restoring from the saved credentials
# files or intitiating an OAuth2 authorization. If authorization is required,
# the user's default browser will be launched to approve the request.
#
# @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials
def authorize
  client_id = Google::Auth::ClientId.from_file CREDENTIALS_PATH
  token_store = Google::Auth::Stores::FileTokenStore.new file: TOKEN_PATH
  authorizer = Google::Auth::UserAuthorizer.new client_id, SCOPE, token_store
  user_id = "me"
  credentials = authorizer.get_credentials user_id
  if credentials.nil?
    url = authorizer.get_authorization_url base_url: OOB_URI
    puts "Open the following URL in the browser and enter the " \
         "resulting code after authorization:\n" + url
    code = gets
    credentials = authorizer.get_and_store_credentials_from_code(
      user_id: user_id, code: code, base_url: OOB_URI
    )
  end
  credentials
end

# Initialize the API
service = Google::Apis::GmailV1::GmailService.new
service.client_options.application_name = APPLICATION_NAME
service.authorization = authorize