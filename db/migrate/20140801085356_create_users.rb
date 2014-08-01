class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :authentication_token
      t.string :email
      t.string :firstname
      t.string :lastname
      t.string :password

      t.timestamps
    end

    add_index :users, :authentication_token, unique: true
    add_index :users, :email, unique: true
  end
end
