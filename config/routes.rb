Rails.application.routes.draw do
  namespace :api do
    resources :todo_lists, only: %i[index create update destroy show], path: :todolists do
      resources :todo_list_items, only: %i[index create update destroy show]
    end
  end

  resources :todo_lists, only: %i[index new], path: :todolists
end
