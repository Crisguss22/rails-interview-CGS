require 'rails_helper'

describe Api::TodoListsController do
  render_views

  describe 'GET index' do
    let!(:todo_list) { TodoList.create(name: 'Setup RoR project') }

    context 'when format is HTML' do
      it 'raises a routing error' do
        expect {
          get :index
        }.to raise_error(ActionController::RoutingError, 'Not supported format')
      end
    end

    context 'when format is JSON' do
      it 'returns a success code' do
        get :index, format: :json

        expect(response.status).to eq(200)
      end

      it 'includes todo list records' do
        get :index, format: :json

        todo_lists = JSON.parse(response.body)

        aggregate_failures 'includes the id and name' do
          expect(todo_lists.count).to eq(1)
          expect(todo_lists[0].keys).to match_array(['id', 'name'])
          expect(todo_lists[0]['id']).to eq(todo_list.id)
          expect(todo_lists[0]['name']).to eq(todo_list.name)
        end
      end
    end
  end

  describe 'POST create' do
    it 'returns success and creates todo_list' do
      post :create, params: { name: 'RoR Project created' }, format: :json

      aggregate_failures 'includes the id and name' do
        expect(response.status).to eq(200)
        expect(TodoList.last.name).to eq('RoR Project created')
      end
    end
  end

  describe 'GET show' do
    let!(:todo_list) { TodoList.create(name: 'Setup RoR project') }

    it 'returns existing todo_list' do
      get :show, params: { id: todo_list.id }, format: :json

      response_todo_list = JSON.parse(response.body) 

      aggregate_failures 'includes the id and name' do
        expect(response_todo_list.keys).to match_array(['id', 'name'])
        expect(response_todo_list['id']).to eq(todo_list.id)
        expect(response_todo_list['name']).to eq(todo_list.name)
      end
    end

    it 'returns error at non-existing todo_list' do
      get :show, params: { id: todo_list.id+1 }, format: :json

      expect(response.status).to eq(404)
    end
  end

  describe 'PATCH update' do
    let!(:todo_list) { TodoList.create(name: 'Setup RoR project') }

    it 'returns success and updates todo_list' do
      patch :update, params: { id: todo_list.id, name: 'RoR Project updated' }, format: :json

      aggregate_failures 'includes the id and name' do
        expect(response.status).to eq(200)
        expect(TodoList.find(todo_list.id).reload.name).to eq('RoR Project updated')
      end
    end

    it 'returns error at non-existing todo_list' do
      patch :update, params: { id: todo_list.id+1 }, format: :json

      expect(response.status).to eq(404)
    end
  end

  describe 'DELETE' do
    let!(:todo_list) { TodoList.create(name: 'Setup RoR project') }

    it 'returns success deleting existing todo_list' do
      delete :destroy, params: { id: todo_list.id }, format: :json

      aggregate_failures 'returns success and destroys todo_list' do
        expect(response.status).to eq(200)
        expect(TodoList.exists?(todo_list.id)).to be false
      end
    end

    it 'returns error deleting non-existing todo_list' do
      delete :destroy, params: { id: todo_list.id+1 }, format: :json

      aggregate_failures 'returns error and does not destroy todo_list' do
        expect(response.status).to eq(400)
        expect(TodoList.exists?(todo_list.id)).to be true
      end
    end
  end
end
