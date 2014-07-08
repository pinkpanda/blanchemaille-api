class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.integer :nb_employees
      t.string :address
      t.string :ceo_name
      t.string :city
      t.string :email
      t.string :image
      t.string :lat
      t.string :link
      t.string :lon
      t.string :name
      t.string :phone
      t.string :type
      t.text :ceo_bio

      t.timestamps
    end
  end
end
