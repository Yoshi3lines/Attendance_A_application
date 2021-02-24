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
      # 確認用showページ
      get 'verifacation'
    end
    collection do
      # 出社中社員ページ
      get 'working_employees'
    end
    resources :attendances, only: [:update] do
      member do
        # 残業申請モーダルウィンドウ
      get 'edit_overtime_request'
      patch 'update_overtime_request'
      end
    end
  end
end