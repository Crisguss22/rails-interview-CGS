class TodoList < ApplicationRecord
  has_many :todo_list_items
end