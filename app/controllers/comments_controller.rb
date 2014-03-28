class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
  @rating = Rating.where(comment_id: @comment.id, user_id: @current_user.id).first
  end

  # GET /comments/new
  def new
    @comment = Comment.new
    @comment.rating.build
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  # POST /comments.json
  def create
    @hotel = Hotel.find(params[:hotel_id])

    @comment = @hotel.comments.new(comment_params)
    @comment.user_id = current_user.id
    @comment.save!
    @comment.rating.new(params[:rating_attributes])
    @comment.rating.comment_id = @comment.id
    @comment.rating.user_id = current_user.id
    @comment.rating.save


    unless @rating
      @rating = Rating.create(comment_id: @comment.id, user_id: current_user.id, score: 0)
    end

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @hotel, notice: 'Comment was successfully created.' }
        format.json { render action: 'show', status: :created, location: @comment }
      else
        format.html { render action: 'new' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to hotels_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:user_id, :hotel_id, :body, rating_attributes: [:score, :comment_id, :user_id])
    end
end
