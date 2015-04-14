FetchIt::Application.routes.draw do
  resources :emails

  get "choose" => "emails#choose"
  get "run_mail" => "emails#run_mail"
  post "choose" => "emails#choose"
  get "home" => "home#index"

end
