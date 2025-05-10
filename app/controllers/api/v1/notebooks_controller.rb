class Api::V1::NotebooksController < ApplicationController
  before_action :authenticate_request
  before_action :set_notebook, only: [:show, :update, :destroy]

  # GET /api/v1/notebooks
  def index
    notebooks = Current.user.notebooks
    render json: notebooks, status: :ok
  end

  # GET /api/v1/notebooks/:id
  def show
    render json: @notebook, status: :ok
  end

  # POST /api/v1/notebooks
  def create
    notebook = Current.user.notebooks.new(notebook_params)
    if notebook.save
      render json: notebook, status: :created
    else 
      render json: {errors: notebook.errors.full_messages}, status: :unprocessable_entity
    end
  end

  # PUT /api/v1/notebooks/:id
  def update
    if @notebook.update(notebook_params)
      render json: @notebook, status: :ok
    else
      render json: {errors: @notebook.errors.full_messages}, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/notebooks/:id
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
