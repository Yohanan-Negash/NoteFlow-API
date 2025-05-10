class Api::V1::NotesController < ApplicationController
  before_action :authenticate_request
  before_action :set_notebook
  before_action :set_note, only: [:show, :update, :destroy]

  def index
    notes = @notebook.notes
    render json: notes, status: :ok
  end

  def show
    render json: @note, status: :ok
  end

  def create
    note = @notebook.notes.new(note_params)
    if note.save
      render json: note, status: :created
    else
      render json: { error: note.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @note.update(note_params)
      render json: @note, status: :ok
    else
      render json: { error: @note.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @note.destroy
    head :no_content
  end

  private
  def set_notebook
    @notebook = Current.user.notebooks.find(param[:notebook_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Notebook not found' }, status: :not_found
  end

  def set_note
    @note = @notebook.notes.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Note not found' }, status: :not_found
  end

  def note_params
    params.require(:note).permit(:title, :content)
  end
end
