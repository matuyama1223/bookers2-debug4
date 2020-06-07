Rails.application.routes.draw do

  get 'rooms/show'
	devise_for :users
	root  'home#top'
	get 'home/about' => "home#about"
	get 'users/follows'=>"users#follows"
	get 'users/follower'=>"users#follower"
	resources :users,only: [:show,:index,:edit,:update]

	resources :books, only: [:new,:create,:index,:show, :edit] do
		resource :favorites, only: [:create,:destroy]
		resources :book_comments, only: [:create,:destroy]
	end
	resources :relationships, only:[:create,:destroy]
	 resources :rooms
end