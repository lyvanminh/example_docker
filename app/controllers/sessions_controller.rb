class SessionsController < ApplicationController
  def index
    unless session.has_key?(:credentials)
      redirect_to oauth2callback_path
    end
    
    client_opts = JSON.parse(session[:credentials])
    auth_client = Signet::OAuth2::Client.new(client_opts)
    server = Google::Apis::GmailV1::GmailService.new()
    server.request_options.authorization = auth_client.access_token
    message              = Mail.new
    message.date         = Time.now
    message.subject      = 'Supertramp'
    message.body         = "<p>Hi Alex, how's life?</p>"
    message.from         = 'lyvanminh1002@gmail.com'
    message.to           = 'lvm10296.2@gmail.com'
    message.content_type = 'text/html'
    message_object = Google::Apis::GmailV1::Message.new(raw:message.to_s)
    server.send_user_message("me", message_object)
    redirect_to send_success_path
  end

  def create
    # client_secrets = Google::APIClient::ClientSecrets.new({"web":{"client_id":"11317113302-3b6v0ljsbml38356mmufqilnn0ho5n4k.apps.googleusercontent.com","project_id":"gmail-api-320114","auth_uri":"https://accounts.google.com/o/oauth2/auth","token_uri":"https://oauth2.googleapis.com/token","auth_provider_x509_cert_url":"https://www.googleapis.com/oauth2/v1/certs","client_secret":"AP5lNqurD-cASiVwN0RKgo4s","redirect_uris":["https://e67bc6767583.ngrok.io/oauth2callback"],"javascript_origins":["https://e67bc6767583.ngrok.io"]}})
    client_secrets = Google::APIClient::ClientSecrets.load("#{Rails.root}/config/client_secrets.json")
    auth_client = client_secrets.to_authorization
    auth_client.update!(
      :scope => 'https://www.googleapis.com/auth/gmail.send',
      :redirect_uri => oauth2callback_url)
    if request['code'] == nil
      auth_uri = auth_client.authorization_uri.to_s
      redirect_to auth_uri
    else
      auth_client.code = request['code']
      auth_client.fetch_access_token!
      auth_client.client_secret = nil
      session[:credentials] = auth_client.to_json
      redirect_to "/"
    end
  end

  def send_success
  
  end
end