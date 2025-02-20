module Api
  class TodoListsController < ApplicationController
    def index
      @todo_lists = TodoList.all

      respond_to :json
    end

    def create
      @todo_list = TodoList.new(name: todo_list_params[:name])
      if @todo_list.save
        render json: @todo_list
      else
        render json: @todo_list.errors.full_messages.to_json, status: 400
      end
    end

    def show
      @todo_list = TodoList.find(params[:id])
      render json: @todo_list
    end

    def update
      @todo_list = TodoList.find(todo_list_params[:id])

      @todo_list.name = todo_list_params[:name] if todo_list_params[:name]
      if @todo_list.save
        render json: @todo_list, status: 200
      else
        render json: @todo_list.errors.full_messages.to_json, status: 400
      end
    end

    def destroy
      @todo_list = TodoList.find_by(id: params[:id])
      status = @todo_list&.destroy ? 200 : 400

      render json: {}, status: 
    end

    private

    def todo_list_params
      params.permit(:name, :id)
    end
  end
end
