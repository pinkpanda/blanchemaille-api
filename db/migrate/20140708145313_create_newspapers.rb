class CreateNewspapers < ActiveRecord::Migration
  def change
    create_table :newspapers do |t|
      t.string :image
      t.string :link
      t.string :newspaper_name
      t.string :title
      t.text :content

      t.timestamps
    end
  end
end
