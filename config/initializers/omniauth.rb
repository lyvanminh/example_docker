Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, '11317113302-3b6v0ljsbml38356mmufqilnn0ho5n4k.apps.googleusercontent.com', 'AP5lNqurD-cASiVwN0RKgo4s', {
    scope: ['email',
            'https://www.googleapis.com/auth/gmail.send'],
    access_type: 'offline'
  }
end