Rails.application.routes.draw do
  root 'home#index'
  resources :payments
  resources :products
  resources :client
  resources :orders
  resources :method_payments

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
