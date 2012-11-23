class BmarksController < ApplicationController
  before_filter :authenticate_user!

  # GET /bmarks
  # GET /bmarks.json
  def index
    # @bmarks = current_user.bmarks.all
    # @bmarks = current_user.bmarks.includes(:taggings).map do |bmark| 
    #   { id: bmark.id, title: bmark.title, link: bmark.link, 
    #     desc: bmark.desc, taggings: bmark.taggings}
    # end

    @bmarks = current_user.bmarks.includes(:taggings => :tag).map do |b|
      taggings = b.taggings.map do |t| 
        {id:t.id, name:t.name, bmark_id: t.bmark_id}
      end
      {id:b.id, title:b.title, link:b.link, desc:b.desc, taggings:taggings}
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bmarks }
    end
  end

  # GET /bmarks/1
  # GET /bmarks/1.json
  def show
    @bmark = Bmark.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @bmark }
    end
  end

  # GET /bmarks/new
  # GET /bmarks/new.json
  def new
    @bmark = Bmark.new
    @bmark.link = params[:link] if params[:link]
    @bmark.title = params[:title] if params[:title]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @bmark }
    end
  end

  # GET /bmarks/1/edit
  def edit
    @bmark = Bmark.find(params[:id])
  end

  # POST /bmarks
  # POST /bmarks.json
  def create
    @bmark = current_user.bmarks.build(params[:bmark])

    respond_to do |format|
      if @bmark.save
        format.html { redirect_to "/", notice: 'Bmark was successfully created.' }
        format.json { render json: @bmark, status: :created, location: @bmark }
      else
        format.html { render action: "new" }
        format.json { render json: @bmark.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /bmarks/1
  # PUT /bmarks/1.json
  def update
    @bmark = current_user.bmarks.find(params[:id])

    respond_to do |format|
      if @bmark.update_attributes(params[:bmark])
        format.html { redirect_to @bmark, notice: 'Bmark was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @bmark.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bmarks/1
  # DELETE /bmarks/1.json
  def destroy
    @bmark = current_user.bmarks.find(params[:id])
    @bmark.destroy

    respond_to do |format|
      format.html { redirect_to bmarks_url }
      format.json { head :no_content }
    end
  end
end
