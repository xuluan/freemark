class CreateBmarks < ActiveRecord::Migration
  def change
    create_table :bmarks do |t|
      t.string :title
      t.string :link
      t.text :desc

      t.timestamps
    end
  end
end
