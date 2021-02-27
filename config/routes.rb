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
      # 1ヶ月承認
      get 'attendances/edit_month_approval'
      patch 'attendances/update_month_approval'
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
      # 残業お知らせモーダル
      get 'edit_overtime_notice'
      patch 'update_overtime_notice'
      # 残業申請確認モーダル
      get 'show_overtime_verifacation'
      # 勤怠変更お知らせモーダル
      get 'edit_one_month_notice'
      patch 'update_one_month_notice'
      # 1ヶ月承認モーダル
      get 'edit_month_approval_notice'
      patch 'update_month_approval_notice'
      # 勤怠ログ
      get 'log'
      end
    end
  end
end