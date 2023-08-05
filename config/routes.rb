Rails.application.routes.draw do
  

  # Defines the root path route ("/")
  
  
  #built-in routes for user authentication, such as sign-up, sign-in, sign-out, password management, etc
  # devise_for :users
  #routes for users
  post 'users/login', to: 'users#login'
  resources :users do
    member do
      post :follow, to: 'follows#create'
      delete :unfollow, to: 'follows#destroy'
    end
  end
  resources :articles do
    resources :likes, only: [:create, :destroy]
    resources :comments, only: [:create, :destroy]
  end
  # if I will write the above line,it will automatically create RESTful routes for me

  # List all articles
  # get '/articles', to: 'articles#index', as: 'articles'
  
  # Show the form for creating a new article
  # get '/articles/new', to: 'articles#new', as: 'new_article'
  
  # Create a new article
  # post '/articles', to: 'articles#create'
  
  # Show a specific article
  # get '/articles/:id', to: 'articles#show', as: 'article'
  
  # Show the form for editing a specific article
  # get '/articles/:id/edit', to: 'articles#edit', as: 'edit_article'
  
  # Update a specific article
  # patch '/articles/:id', to: 'articles#update'
  # put '/articles/:id', to: 'articles#update'
  
  # Delete a specific article
  # delete '/articles/:id', to: 'articles#destroy'
  
  
end
