Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
  
  resource :serviceworker, only: %i[index]
  get 'sitemap', to: redirect("https://s3-ap-northeast-1.amazonaws.com/#{Rails.application.credentials.aws[:s3_bucket_name]}/sitemaps/sitemap.xml.gz")
  root 'static_pages#top'
  get 'privacy_policy', to: 'static_pages#privacy_policy'
  get 'terms_of_service', to: 'static_pages#terms_of_service'
  
  resource :contacts, only: %i[new create]
  post 'contacts/confirm', to: 'contacts#confirm', as: 'confirm'
  
  resources :password_resets, only: %i[new create edit update]
  
  namespace :togo_inu_shitsuke_hiroba do
    get 'top', to: 'static_pages#top'
    get 'detail', to: 'static_pages#detail'
    get 'compliance_confirmations', to: 'static_pages#compliance_confirmations'
    resource :sessions, only: %i[new create destroy]
    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy', as: :logout
    
    resource :entries, only: %i[create update]
    
    resources :users, only: %i[new create show]
    resources :dogs, only: %i[show edit update]
    
    get 'signup', to: 'users#new', as: :signup
    
    get 'dog_registration', to: 'dog_registration#new'
    post 'dog_registration', to: 'dog_registration#create'
    post 'dog_registration/confirm', to: 'dog_registration#confirm'
  end

  namespace :admin do
    root 'dashboards#index'
    resources :dogrun_places, only: %i[index create]
    resources :users, only: %i[index edit update] do
      collection do
        get 'page/:page', action: :index
        get 'search', to: 'entries#search'
        post 'search', to: 'users#search'
      end
    end
    resources :entries, only: %i[index destroy] do
      collection do
        get 'page/:page', action: :index
        get 'search', to: 'entries#search'
        post 'search', to: 'entries#search'
      end
    end
    resource :sessions, only: %i[new create destroy]
    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'
  end
end
