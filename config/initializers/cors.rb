Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins '*'  # Replace this with your frontend's origin
      resource '*', headers: :any, methods: [:get, :post, :put, :patch, :delete, :options, :head]
    end
  end