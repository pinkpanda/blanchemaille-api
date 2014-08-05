class AddInfoToPages < ActiveRecord::Migration
  def change
    add_column :pages, :info, :string
  end
end
