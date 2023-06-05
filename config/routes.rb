# frozen_string_literal: true

Rails.application.routes.draw do
  root 'contacts#index'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  resources :contacts do
    collection do
      post 'import_data', to: 'contacts#import_data'
      get 'last_import_log', to: 'contacts#last_import_log'
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
