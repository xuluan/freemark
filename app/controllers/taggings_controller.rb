class TaggingsController < ApplicationController
  before_filter :authenticate_user!

  # GET /tags
  # GET /tags.json
  def index
    b = Bmark.find(params[:bmark_id])
    @taggings = b.taggings.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @taggings }
    end
  end

  # POST /tags
  # POST /tags.json
  def create
    #should check bmark belongs to current user
    @tag = Tagging.createOne(params[:name], params[:bmark_id], current_user.id)

    respond_to do |format|
      if @tag
        format.html { redirect_to @tag, notice: 'Tag was successfully created.' }
        format.json { render json: @tag, status: :created, location: @tag }
      else
        format.html { render action: "new" }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /tags/1
  # DELETE /tags/1.json
  def destroy
    Tagging.deleteOne(params[:name], params[:bmark_id], current_user.id)

    respond_to do |format|
      format.html { redirect_to tags_url }
      format.json { head :no_content }
    end
  end
end
