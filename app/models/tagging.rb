class Tagging < ActiveRecord::Base
  attr_accessible :bmark_id, :tag_id

  belongs_to :bmark
  belongs_to :tag

  delegate :name, to: :tag

  def self.createOne(name, bmark_id, user_id)
    tag = Tag.where(name: name, user_id: user_id).first_or_create do |tag|
      tag.name = name
      tag.user_id = user_id
    end

    return nil unless tag
    
    Tagging.where(bmark_id: bmark_id, tag_id: tag.id).first_or_create do |tagging|
      tagging.bmark_id = bmark_id
      tagging.tag_id = tag.id
    end

  end

  def self.deleteOne(name, bmark_id, user_id)
    tag = Tag.where(name: name, user_id: user_id).first

    if tag
      tagging = Tagging.where(bmark_id: bmark_id, tag_id: tag.id).first
      tagging.destroy if tagging
    end

  end

end
