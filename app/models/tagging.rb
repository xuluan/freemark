class Tagging < ActiveRecord::Base
  attr_accessible :bmark_id, :tag_id

  belongs_to :bmark
  belongs_to :tag

  delegate :name, to: :tag

end
