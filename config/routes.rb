Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  
  # NOTE:
  # resources :articles
  # if I will write the above line,it will automatically create RESTful routes for me

  # List all articles
  get '/articles', to: 'articles#index', as: 'articles'
  
  # Show the form for creating a new article
  get '/articles/new', to: 'articles#new', as: 'new_article'
  
  # Create a new article
  post '/articles', to: 'articles#create'
  
  # Show a specific article
  get '/articles/:id', to: 'articles#show', as: 'article'
  
  # Show the form for editing a specific article
  get '/articles/:id/edit', to: 'articles#edit', as: 'edit_article'
  
  # Update a specific article
  patch '/articles/:id', to: 'articles#update'
  put '/articles/:id', to: 'articles#update'
  
  # Delete a specific article
  delete '/articles/:id', to: 'articles#destroy'
  
  
end
