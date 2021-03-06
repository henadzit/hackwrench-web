Rails.application.routes.draw do
  devise_for :users, :controllers => { :sessions => 'sessions', :omniauth_callbacks => 'omniauth_callbacks' } do
    # get '/users/sign_in', to: 'sessions#new'
  end

  root to: 'home#index'

  get '/client', to: 'client/chats#index'

  namespace :client do
    get '/chats/configure/:chat_id', to: 'chats#configure', as: 'chats_configure'

    resources :chats, only: [:index] do
      get '/trello', to: 'trello#index'
      post '/trello/webhook_enabled', to: 'trello#webhook_enabled'
      post '/trello/webhook_disabled', to: 'trello#webhook_disabled'

      namespace :github do
        get '/setup_webhook_howto', to: 'repositories#setup_webhook_howto'
        post '/repositories/:id', to: 'repositories#update'

        resources :repositories, only: [:index, :show]
      end

      namespace :gitlab do
        resources :repositories, only: [:index, :show]
      end
    end
  end

  namespace :webhooks do
    post '/github/:chat_id', to: 'github#callback', as: 'github'
    post '/gitlab/:chat_id', to: 'gitlab#callback', as: 'gitlab'

    get '/trello/:chat_id', to: 'trello#callback_get', as: 'trello_get'
    post '/trello/:chat_id', to: 'trello#callback', as: 'trello'
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
