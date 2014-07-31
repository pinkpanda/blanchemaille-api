class AddWorkedAtToWorks < ActiveRecord::Migration
  def change
    add_column :works, :worked_at, :datetime
  end
end
