class CreateBmarks < ActiveRecord::Migration
  def change
    create_table :bmarks do |t|
      t.string :title, null: false
      t.string :link, null: false
      t.text :desc

      t.timestamps
    end
  end
end
