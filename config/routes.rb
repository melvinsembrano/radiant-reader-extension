ActionController::Routing::Routes.draw do |map|
  map.namespace :admin, :path_prefix => 'admin/readers' do |admin|
    admin.resources :messages, :member => [:preview, :deliver]
    admin.resources :groups, :has_many => [:memberships, :permissions, :group_invitations, :messages]
    admin.resource :reader_configuration, :controller => 'reader_configuration'
  end

  map.namespace :admin do |admin|
    admin.resources :readers, :except => [:show]
  end

  map.resources :readers
  map.resources :messages, :only => [:index, :show], :member => [:preview]
  map.resources :groups, :only => [:index, :show] do |group|
    group.resources :messages, :only => [:index, :show], :member => [:preview]
  end

  map.resource :reader_session
  map.resource :reader_activation, :only => [:show, :new]
  map.resource :password_reset
  
  map.activate_me '/activate/:id/:activation_code', :controller => 'reader_activations', :action => 'update'
  map.repassword_me 'repassword/:id/:confirmation_code', :controller => 'password_resets', :action => 'edit'
  map.reader_register '/register', :controller => 'readers', :action => 'new'
  map.reader_login '/login', :controller => 'reader_sessions', :action => 'new'
  map.reader_account '/account', :controller => 'readers', :action => 'edit'
  map.reader_profile '/profile', :controller => 'readers', :action => 'show'
  map.reader_logout '/logout', :controller => 'reader_sessions', :action => 'destroy'
  map.reader_permission_denied '/permission_denied', :controller => 'readers', :action => 'permission_denied'
  map.reader_dashboard '/dashboard', :controller => 'readers', :action => 'dashboard'
end
