require 'rails_helper'

describe Api::TodoListItemsController do
  render_views
  let!(:todo_list) { TodoList.create(name: 'Setup RoR project') }

  describe 'GET index' do
    let!(:todo_list_item1) { TodoListItem.create(todo_list:, title: 'RoR project item 1') }
    let!(:todo_list_item2) { TodoListItem.create(todo_list:, title: 'RoR project item 2') }

    it 'returns a success code' do
      get :index, params: { todo_list_id: todo_list.id }, format: :json

      expect(response.status).to eq(200)
    end

    it 'includes todo_list items' do
      get :index, params: { todo_list_id: todo_list.id }, format: :json

      todo_list_items = JSON.parse(response.body)

      aggregate_failures 'includes the id and name' do
        expect(todo_list_items.count).to eq(2)
        expect(todo_list_items[0].keys).to match_array(["id", "title", "description", "completed", "todo_list_id", "created_at", "updated_at"])
        expect(todo_list_items[0]['id']).to eq(todo_list_item1.id)
        expect(todo_list_items[0]['description']).to eq(todo_list_item1.description)
      end
    end
  end

  describe 'POST create' do
    it 'returns success and creates todo_list' do
      post :create, params: { todo_list_id: todo_list.id, title: 'RoR Project item' }, format: :json

      aggregate_failures 'includes the id and name' do
        expect(response.status).to eq(200)
        expect(todo_list.reload.todo_list_items.last.title).to eq('RoR Project item')
      end
    end

    it 'returns error when todo_list does not exist' do
      post :create, params: { todo_list_id: todo_list.id+1, title: 'RoR Project item' }, format: :json

      expect(response.status).to eq(404)
    end
  end

  describe 'GET show' do
    let!(:todo_list_item) { TodoListItem.create(todo_list:, title: 'RoR project item', description: "Item description", completed: false) }

    it 'returns existing todo_list_item' do
      get :show, params: { todo_list_id: todo_list.id, id: todo_list_item.id }, format: :json

      response_todo_list_item = JSON.parse(response.body) 

      aggregate_failures 'includes the id and title' do
        expect(response_todo_list_item['id']).to eq(todo_list_item.id)
        expect(response_todo_list_item['title']).to eq(todo_list_item.title)
        expect(response_todo_list_item['description']).to eq(todo_list_item.description)
        expect(response_todo_list_item['completed']).to eq(todo_list_item.completed)
      end
    end

    it 'returns error at non-existing todo_list' do
      get :show, params: { todo_list_id: todo_list.id, id: todo_list_item.id+1 }, format: :json

      expect(response.status).to eq(404)
    end
  end

  describe 'PATCH update' do
    let!(:todo_list_item) { TodoListItem.create(todo_list:, title: 'RoR project item', description: 'Item description', completed: false) }

    it 'returns success and updates todo_list_item' do
      patch :update, params: { todo_list_id: todo_list.id, id: todo_list_item.id, title: 'RoR Project item updated', completed: true }, format: :json

      aggregate_failures 'includes the id and other attributes' do
        expect(response.status).to eq(200)
        expect(todo_list_item.reload.title).to eq('RoR Project item updated')
        expect(todo_list_item.description).to eq('Item description')
        expect(todo_list_item.completed).to eq(true)
      end
    end

    it 'returns error at non-existing todo_list_item' do
      patch :update, params: { todo_list_id: todo_list.id, id: todo_list_item.id+1, title: 'RoR Project item updated' }, format: :json

      aggregate_failures 'returns error and does not update object' do
        expect(response.status).to eq(404)
        expect(todo_list_item.reload.title).to eq('RoR project item')
      end
    end
  end

  describe 'DELETE' do
    let!(:todo_list_item) { TodoListItem.create(todo_list:, title: 'RoR project item', description: 'Item description', completed: false) }

    it 'returns success deleting existing todo_list' do
      delete :destroy, params: { todo_list_id: todo_list.id, id: todo_list_item.id }, format: :json      

      aggregate_failures 'returns success and destroys todo_list_item' do
        expect(response.status).to eq(200)
        expect(TodoListItem.exists?(todo_list_item.id)).to be false
      end
    end

    it 'returns error deleting non-existing todo_list' do
      delete :destroy, params: { todo_list_id: todo_list.id, id: todo_list_item.id+1 }, format: :json

      aggregate_failures 'returns error and does not destroy todo_list_item' do
        expect(response.status).to eq(400)
        expect(TodoListItem.exists?(todo_list_item.id)).to be true
      end
    end
  end
end
