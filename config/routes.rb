Rails.application.routes.draw do
  
  resources :payments
  resources :products
  resources :client
  resources :orders
  resources :method_payments
  root 'orders#new'
  post 'orders/pago', to: 'orders#pago'
  post 'orders/met_pago', to: 'orders#met_pago'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
