class AddSlugToModels < ActiveRecord::Migration
  def change
    add_column :newspapers, :slug, :string
    add_index :newspapers, :slug, unique: true

    add_column :organizations, :slug, :string
    add_index :organizations, :slug, unique: true

    add_column :partners, :slug, :string
    add_index :partners, :slug, unique: true

    add_column :works, :slug, :string
    add_index :works, :slug, unique: true
  end
end
