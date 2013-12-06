Hashdb::Application.routes.draw do

  get 'md5_hashes' => 'md5_hashes#index', :as => :md5_hashes
  get 'md5_hashes/new' => 'md5_hashes#new', :as => :md5_hashes_new
#  post 'md5_hashes' => 'md5_hashes#create', :as => :md5_hashes_create
  post 'md5_hashes/paste_hashes' => 'md5_hashes#paste_hashes', :as => :md5_hashes_paste_hashes
  post 'md5_hashes/upload_hashes' => 'md5_hashes#upload_hashes', :as => :md5_hashes_upload_hashes
  post 'md5_hashes/paste_passwords' => 'md5_hashes#paste_passwords', :as => :md5_hashes_paste_passwords
  post 'md5_hashes/upload_passwords' => 'md5_hashes#upload_passwords', :as => :md5_hashes_upload_passwords
  get 'md5_hashes/unsolved' => 'md5_hashes#unsolved', :as => :md5_hashes_unsolved
  get 'md5_hashes/wordlist' => 'md5_hashes#wordlist', :as => :md5_hashes_wordlist
  get 'md5_hashes/stats' => 'md5_hashes#stats', :as => :md5_hashes_stats
  get 'md5_hashes/deleteall' => 'md5_hashes#deleteall', :as => :md5_hashes_deletall
  get 'md5_hashes/:hex_hash' => 'md5_hashes#show', :as => :md5_hash

  get 'hash_lists' => 'hash_lists#index', :as => :hash_lists
  get 'hash_lists/new' => 'hash_lists#new', :as => :hash_lists_new
  post 'hash_lists' => 'hash_lists#create', :as => :hash_lists_create
  get 'hash_lists/:id' => 'hash_lists#show', :as => :hash_list
  put 'hash_lists/:id' => 'hash_lists#update', :as => :hash_list_update
  get 'hash_lists/:id/edit' => 'hash_lists#edit', :as => :hash_list_edit
  delete 'hash_lists/:id' => 'hash_lists#destroy', :as => :hash_list_destory

  
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
