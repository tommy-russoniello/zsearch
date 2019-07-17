Rails.application.routes.draw do
  root to: redirect('/organization_search')

  resources :organizations, only: %i[index show]
  resources :tickets, only: %i[index show]
  resources :users, only: %i[index show]

  get 'organization_search' => 'organizations#search', as: 'organization_search'
  get 'ticket_search' => 'tickets#search', as: 'ticket_search'
  get 'user_search' => 'users#search', as: 'user_search'
end
