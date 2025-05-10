class Api::V1::NotebooksController < ApplicationController
  before_action :authenticate_request
  before_action :set_notebook, only: [:show, :update, :destroy]

  def index
    notebooks = Current.user.notebooks
    render json: notebooks, status: :ok
  end

  def show
    render json: @notebook, status: :ok
  end

  def create
    notebook = Current.user.notebooks.new(notebook_params)
    if notebook.save
      render json: notebook, status: :created
    else 
      render json: {errors: notebook.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def update
    if @notebook.update(notebook_params)
      render json: @notebook, status: :ok
    else
      render json: {errors: @notebook.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def destroy
    @notebook.destroy
    head :no_content
  end

  private
  def set_notebook
    @notebook = Current.user.notebooks.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: {errors: ['Notebook not found']}, status: :not_found
  end

  def notebook_params
    params.require(:notebook).permit(:name)
  end
end
