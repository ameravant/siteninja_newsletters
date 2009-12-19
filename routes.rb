namespace :admin do |admin|
  admin.resources :newsletters do |letter|
    letter.resources :newsletter_blasts, :as => "blasts"
    letter.resources :images, :member => { :reorder => :put }, :collection => { :reorder => :put }
  end
end

map.resources :people, :as => "subscriptions"