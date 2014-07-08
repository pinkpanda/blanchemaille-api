class CreatePartners < ActiveRecord::Migration
  def change
    create_table :partners do |t|
      t.string :image
      t.string :link
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
