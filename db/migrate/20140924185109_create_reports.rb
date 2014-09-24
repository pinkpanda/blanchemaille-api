class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :file
      t.string :slug
      t.string :title

      t.timestamps
    end

    add_index :reports, :slug, unique: true
  end
end
