Rails.application.routes.draw do
  root 'static_pages#top'
  get 'privacy_policy', to: 'static_pages#privacy_policy'
  get 'terms_of_service', to: 'static_pages#terms_of_service'

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
  get '/service-worker.js', to: 'service_worker#service_worker'
  get '/offline.html', to: 'service_worker#offline'
  get 'sitemap', to: redirect("https://s3-ap-northeast-1.amazonaws.com/#{Rails.application.credentials.aws[:s3_bucket_name]}/sitemaps/sitemap.xml.gz")
  
  resource :contacts, only: %i[new create]
  post 'contacts/confirm', to: 'contacts#confirm', as: 'confirm'
  
  resources :password_resets, only: %i[new create edit update]
  
  namespace :togo_inu_shitsuke_hiroba do
    get 'top', to: 'static_pages#top'
    get 'detail', to: 'static_pages#detail'
    resource :sessions, only: %i[new create destroy]
    post '/guest_login', to: 'sessions#guest_login'
    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy', as: :logout
    
    resource :entries, only: %i[create update]
    resources :users, only: %i[new create show]
    resources :dogs, only: %i[show edit update]
    resources :posts, only: %i[new create index show] do
      member do
        resources :articles, only: %i[new create]
        resources :embed, only: %i[new create]
      end
    end
    
    get 'signup', to: 'users#new', as: :signup
    
    get 'dog_registration', to: 'dog_registration#new'
    post 'dog_registration', to: 'dog_registration#create'
    post 'dog_registration/confirm', to: 'dog_registration#confirm'
  end
  
  namespace :admin do
    root 'dashboards#index'
    resources :dogrun_places, only: %i[index create]

    resources :posts, only: %i[new create edit update destory] do
      collection do
        get 'page/:page', action: :index
        get 'search', to: 'posts#search'
        post 'search', to: 'posts#search'
      end
      member do
        patch 'start_to_publish', to: 'posts#start_to_publish'
        patch 'cancel_to_publish', to: 'posts#cancel_to_publish'
      end
    end
    
    resources :staffs, only: %i[index create destroy] do
      member do
        patch 'enable_notification', to: 'staffs#enable_notification'
        patch 'disable_notification', to: 'staffs#disable_notification'
      end
    end

    resources :dogs, only: %i[index] do
      collection do
        get 'page/:page', action: :index
        get 'search', to: 'dogs#search'
        post 'search', to: 'dogs#search'
      end
    end

    resources :users, only: %i[index new create destroy] do
      collection do
        get 'page/:page', action: :index
        get 'search', to: 'users#search'
        post 'search', to: 'users#search'
      end
      member do
        patch 'deactivation', to: 'users#deactivation'
        patch 'activation', to: 'users#activation'
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
