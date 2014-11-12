class AddIframeToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :iframe, :boolean, default: false
  end
end
