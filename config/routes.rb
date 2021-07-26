Rails.application.routes.draw do
  get "/" => "sessions#index"
  get "/oauth2callback" => "sessions#create"
  get "send_success" => "sessions#send_success"
end
