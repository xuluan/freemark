class Bmark < ActiveRecord::Base
  attr_accessible :desc, :link, :title
  validates_presence_of :title, :link
  validates :link, format: {
    with: /\Ahttps?\:\/\/.+\Z/i,
    message: "invalid url" }  
end
