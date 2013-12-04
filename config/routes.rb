Hashdb::Application.routes.draw do
  match 'md5_hashes/pastehashes' => 'md5_hashes#pastehashes'
  match 'md5_hashes/importhashes' => 'md5_hashes#importhashes'
  match 'md5_hashes/pastesolutions' => 'md5_hashes#pastesolutions'
  match 'md5_hashes/importsolutions' => 'md5_hashes#importsolutions'
  match 'md5_hashes/unsolved' => 'md5_hashes#unsolved'
  match 'md5_hashes/wordlist' => 'md5_hashes#wordlist'
  match 'md5_hashes/uploadhashes' => 'md5_hashes#uploadhashes'
  match 'md5_hashes/upload' => 'md5_hashes#upload'
  resources :md5_hashes

  match 'users/pasteuserhashes' => 'users#pasteuserhashes'
  match 'users/importuserhashes' => 'users#importuserhashes'
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
