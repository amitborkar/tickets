Tickets::Application.routes.draw do

  resources :alipay do
    member do
      get "pay"
    end
    collection do
      get "return"
      post "notify"
    end
  end

  get "manuals/spot"

  get "manuals/agent"

  resources :messages

  get "home/index"

  resources :purchase_histories

  resources :agent_purchase_histories

  resources :all_purchase_histories

  resources :all_reservations

  resources :roles do
    collection do
      get "menu_groups"
    end
  end

  resources :spot_purchases do
    collection do
      get "reservations"
      get "report"
      put "update_settled"
    end
  end

  resources :all_purchases do
    collection do
      get "reservations"
    end
  end

  resources :agent_purchases do
    collection do
      get "reservations"
      get "report"
      put "update_settled"
    end
  end

  resources :all_rfps

  resources :agent_spots do
    collection do
      get "applied"
    end
  end

  resources :spot_agents do
    collection do
      get "applied"
    end
  end


  resources :spot_reservations do
    collection do
      get 'today'
    end
  end

  resources :reservations do
    collection do
      post 'search'
      get 'new_individual'
      get 'new_team'
      post 'create_individual'
      post 'create_team'
      get 'used_contacts'
      get 'unverified'
      get 'done'
      post 'notify'
    end
    member do
      put 'update_individual'
      put 'update_team'
      get 'print'
      put 'verify'
      get 'pay'
    end
  end

  resources :agent_rfps do
    member do
      put 'accept'
      put 'reject'
    end
  end

  resources :rfps do
    member do
      put 'accept'
      get 'edit_accept'
      put 'reject'
    end
  end

  resources :agent_prices

  resources :tickets

  resources :seasons

  resources :agents do
    member do
      put 'disable'
      put 'enable'
    end
  end
  resources :cities
  resources :spots do
    member do
      put 'disable'
      put 'enable'
    end
  end
  resources :sessions do
    collection do
      get 'new_spot'
      get 'new_agent'
    end
  end
  resources :users do
    member do
      get 'edit_myself'
      put 'update_myself'
    end
  end

  resources :agent_users

  resources :agent_roles do
    collection do
      get "menu_groups"
    end
  end

  get 'reports/spot_output'
  post 'reports/spot_output'
  get 'reports/spot_output_rate'
  post 'reports/spot_output_rate'
  get 'reports/spot_checkin'
  post 'reports/spot_checkin'
  get 'reports/spot_agent_output'
  post 'reports/spot_agent_output'
  get 'reports/spot_month_reservations'
  post 'reports/spot_month_reservations'
  post 'reports/spot_month_output'
  post 'reports/spot_month_output'

  get 'reports/generate_spot_output'
  post 'reports/generate_spot_output'
  get 'reports/generate_spot_output_rate'
  post 'reports/generate_spot_output_rate'
  get 'reports/generate_spot_checkin'
  post 'reports/generate_spot_checkin'
  get 'reports/generate_spot_agent_output'
  post 'reports/generate_spot_agent_output'
  get 'reports/generate_spot_month_reservations'
  post 'reports/generate_spot_month_reservations'
  post 'reports/generate_spot_month_output'
  post 'reports/generate_spot_month_output'
  

  get 'reports/agent_output'
  post 'reports/agent_output'
  get 'reports/agent_output_rate'
  post 'reports/agent_output_rate'
  get 'reports/agent_checkin'
  post 'reports/agent_checkin'
  get 'reports/agent_spot_output'
  post 'reports/agent_spot_output' 
  get 'reports/agent_user_output'
  post 'reports/agent_user_output' 
  
  get 'reports/generate_agent_output'
  post 'reports/generate_agent_output'
  get 'reports/generate_agent_output_rate'
  post 'reports/generate_agent_output_rate'
  get 'reports/generate_agent_checkin'
  post 'reports/generate_agent_checkin'
  get 'reports/generate_agent_spot_output'
  post 'reports/generate_agent_spot_output' 
   get 'reports/generate_agent_user_output'
  post 'reports/generate_agent_user_output'

  match 'user/edit' => 'users#edit', :as => :edit_current_user
  match 'signup' => 'users#new', :as => :signup
  match 'logout' => 'sessions#destroy', :as => :logout

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
#  root :to => "public/index.html"

# See how all your routes lay out with "rake routes"

# This is a legacy wild controller route that's not recommended for RESTful applications.
# Note: This route will make all actions in every controller accessible via GET requests.
# match ':controller(/:action(/:id(.:format)))'
end
