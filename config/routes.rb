Rails.application.routes.draw do

  root 'static_pages#top'
  get '/signup', to: 'users#new'
  
  # ログイン機能
  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :bases
  resources :users do
    collection { post :import }
    member do
      # 基本情報の修正ページ
      get 'edit_basic_info'
      patch 'update_basic_info'
      # ユーザー情報変更フォーム
      patch 'update_index'
      # 勤怠変更ページ
      get 'attendances/edit_one_month'
      patch 'attendances/update_one_month'
    end
    collection do
      get 'working_employees'
    end
    resources :attendances, only: :update
  end
end