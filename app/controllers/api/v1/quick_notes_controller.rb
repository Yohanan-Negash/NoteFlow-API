class Api::V1::QuickNotesController < ApplicationController
  before_action :authenticate_request
  before_action :set_quick_note, only: [ :show, :update, :destroy ]

  # GET /api/v1/quick_notes
  def index
    quick_notes = Current.user.quick_notes
    render json: quick_notes, status: :ok
  end

  # GET /api/v1/quick_notes/:id
  def show
    render json: @quick_note, status: :ok
  end

  # POST /api/v1/quick_notes
  def create
    quick_note = Current.user.quick_notes.new(quick_note_params)
    if quick_note.save
      render json: quick_note, status: :created
    else
      render json: { error: quick_note.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT /api/v1/quick_notes/:id
  def update
    if @quick_note.update(quick_note_params)
      render json: @quick_note, status: :ok
    else
      render json: { error: @quick_note.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/quick_notes/:id
  def destroy
    @quick_note.destroy
    head :no_content
  end

  # POST /api/v1/quick_notes/purge_expired
  def purge_expired
    DeleteExpiredQuickNotesJob.perform_later
    head :accepted
  end

  private

  def set_quick_note
    @quick_note = Current.user.quick_notes.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Quick note not found" }, status: :not_found
  end

  def quick_note_params
    params.require(:quick_note).permit(:content)
  end
end
