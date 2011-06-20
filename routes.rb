namespace :admin do |admin|
  admin.resources :newsletters do |letter|
    letter.resources :newsletter_blasts, :as => "blasts"
    letter.resources :images, :member => { :reorder => :put }, :collection => { :reorder => :put, :add_multiple => :get }
  end
end

map.resources :people, :as => "subscriptions"