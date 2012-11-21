class Tag < ActiveRecord::Base
  attr_accessible :name
  validates_presence_of :name

  belongs_to :user
  has_many :taggings, dependent: :destroy

end
