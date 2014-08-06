class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.datetime :scheduled_at
      t.string :place
      t.string :slug
      t.string :title
      t.text :content

      t.timestamps
    end

    add_index :events, :slug, unique: true
  end
end
