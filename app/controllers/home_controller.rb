class HomeController < ApplicationController
  before_filter :authenticate_user!
  
  def index
  end

  def get
  end

  def save
    doc = Nokogiri::HTML(params["import_file"].read)
    doc.search('a').each do |a|
      current_user.bmarks.create(title: a.text, link: a['href']) 
    end
    redirect_to "/", notice: 'Import success.' 
  end

end
