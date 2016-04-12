Rails.application.routes.draw do

  get 'messages/new'

  get 'messages/index'

  get 'messages/show'

  root 'welcome#index'

  resources :users, except: [:show, :edit] do
    collection do
      get 'search' => 'users#index'
    end
  end

  get '/users/:id/messages/new' => 'messages#new'
  post '/users/:id/messages' => 'messages#create'

  resources :messages do
    member do
      get 'mark_read' => 'messages#mark_read'
    end
  end

  get  '/sign_up'  => 'users#new'
  get  '/login'    => 'sessions#new'
  post '/login'    => 'sessions#create'
  delete '/logout' => 'sessions#destroy'

  get '/profile'      => 'users#show'
  get '/profile/edit' => 'users#edit'
end
