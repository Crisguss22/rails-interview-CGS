module Api
  class TodoListItemsController < ApplicationController
    def index
      @todo_list_items = TodoListItem.where(todo_list_id: todo_list_items_params[:todo_list_id])

      render json: @todo_list_items.to_json
    end

    def create
      todo_list = TodoList.find_by(id: todo_list_items_params[:todo_list_id])
      return render json: { error: 'TodoList does not exist' }, status: 404 unless todo_list.present?

      @todo_list_item = TodoListItem.new(todo_list: todo_list, title: todo_list_items_params[:title], description: todo_list_items_params[:description])
      if @todo_list_item.save
        render json: @todo_list_item
      else
        render json: {}, status: 400
      end
    end

    def show
      @todo_list_item = TodoListItem.find_by(id: params[:id])
      if @todo_list_item.present?
        render json: @todo_list_item
      else
        render json: {}, status: 404
      end
    end

    def update
      @todo_list_item = TodoListItem.find_by(id: params[:id])
      return render json: {}, status: 404 unless @todo_list_item.present?

      @todo_list_item.title = todo_list_items_params[:title] if todo_list_items_params[:title]
      @todo_list_item.description = todo_list_items_params[:description] if todo_list_items_params[:description]
      @todo_list_item.completed = todo_list_items_params[:completed] if todo_list_items_params[:completed]
      if @todo_list_item.save
        render json: @todo_list_item
      else
        render json: @todo_list_item.errors.full_messages.to_json, status: 400
      end
    end

    def destroy
      @todo_list_item = TodoListItem.find_by(id: params[:id])
      status = @todo_list_item&.destroy ? 200 : 400

      render json: {}, status: 
    end

    private

    def todo_list_items_params
      params.permit(:todo_list_id, :title, :description, :completed)
    end
  end
end
