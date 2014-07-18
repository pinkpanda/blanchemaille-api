class RenameTypeToOrganizations < ActiveRecord::Migration
  def change
    rename_column :organizations, :type, :sector
  end
end
