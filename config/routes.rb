Hashdb::Application.routes.draw do
  
  get "plain_texts" => 'plain_text#index'
  get "plain_texts/new" => 'plain_text#new'
  post 'plain_texts' => 'plain_text#create'
  post 'plain_texts/paste' => 'plain_text#paste', :as => :plain_texts_paste
  post 'plain_texts/upload' => 'plain_text#upload', :as => :plain_texts_upload
  get 'plain_texts/:id' => 'plain_text#show', :as => :plain_text

  get 'md5_hashes' => 'md5_hashes#index', :as => :md5_hashes
  get 'md5_hashes/new' => 'md5_hashes#new', :as => :md5_hashes_new
  post 'md5_hashes' => 'md5_hashes#create', :as => :md5_hashes_create
  post 'md5_hashes/paste' => 'md5_hashes#paste', :as => :md5_hashes_paste
  post 'md5_hashes/upload' => 'md5_hashes#upload', :as => :md5_hashes_upload
  get 'md5_hashes/unsolved' => 'md5_hashes#unsolved', :as => :md5_hashes_unsolved
  get 'md5_hashes/stats' => 'md5_hashes#stats', :as => :md5_hashes_stats
  get 'md5_hashes/:md5_value' => 'md5_hashes#show', :as => :md5_hash

  
  resources :users

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
